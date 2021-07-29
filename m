Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7283DAEC0
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 00:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234305AbhG2WR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 18:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230117AbhG2WRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jul 2021 18:17:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EE8C0613C1
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:17:52 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id i10so8678474pla.3
        for <kvm@vger.kernel.org>; Thu, 29 Jul 2021 15:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u/ilw5NBsJP2nmfyHHjlurYIq9TKi0gAKv2Zlvey2RQ=;
        b=iXGP91wf4OD7DIgLvU0aEpgvSVV8t+Qo7h/khRV7r9XjB3YXodcxAisfJqkUiFfZVo
         uhYuF2xP/aaD5jMqrPBHziMaTTzcHOYIXrUj0ymvflER627ZyMRfYXIJ+2ecEgOdQYFq
         OPokrPnYKzrpY28qLjfS/2kDH2yby5xHdcv1eG6/Jwu04A5jsXKcfCTGytafS6F1HfDL
         lnCmIA5UGS8alBwdl+Y21xoWu0M+SgVGhGCr4GoNOC+5vxE2v9T99ZeJ/V9ArLL6l/PB
         HBkKvZvgxgDmAXiZrokSdtopoAhlUkEWixyfWEooNVbrFq54cty6TzQOZQUoSVuAENZr
         NVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u/ilw5NBsJP2nmfyHHjlurYIq9TKi0gAKv2Zlvey2RQ=;
        b=kxIA4onLhEifQ6DSdgm/NUXtFRNqZXA7RY1T4WNVHzxeG9AscN3I3LIO1m+HiMoVsJ
         IIEpR+lwBl6vEgBxbXLC3pSeuXU4fnnsvPr7nE9sjfKpbpr0gEWCVNi2fJvqNETEU4P2
         xZX7kfKXU7pRa07BqpTjYTPUNTKWTyivfFE7pj6JcGLaRLJF5cIEmrFxEadsF4nZBrYm
         LUqQ3bQBGElWhajEHV3bZ/wS8mrJ39FnTeVDIx6Qw8OUTPVpR3lLiNT4qliWJb6t5mP4
         cXoPh8KdxWEowBNImf5ErWlwu00Di6KSxkzWrJKA1fLsvjT/6XuuFKYse8F41Ht+Knu3
         z1+w==
X-Gm-Message-State: AOAM532pOeL1bMSTSOJ5DST/LdWOODGJ2YzbY0mOBVJEsLCVr+iLNYcY
        SKtpo0BMAaZxO9Fg8d+XGRLFqg==
X-Google-Smtp-Source: ABdhPJxNdMwRYF6ewrVP/p926bsrmvoQLpd3Z3rK+e9SQlATNhMyMA66r9XA0q3U1bfPe2CULBPeeA==
X-Received: by 2002:a62:e809:0:b029:32c:2dcf:60ed with SMTP id c9-20020a62e8090000b029032c2dcf60edmr7283033pfi.5.1627597071180;
        Thu, 29 Jul 2021 15:17:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k6sm5063456pgb.43.2021.07.29.15.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 15:17:50 -0700 (PDT)
Date:   Thu, 29 Jul 2021 22:17:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Lars Bull <larsbull@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3 V3] KVM, SEV: Add support for SEV intra host migration
Message-ID: <YQMpChJVo13/Njnc@google.com>
References: <20210726195015.2106033-1-pgonda@google.com>
 <20210726195015.2106033-3-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726195015.2106033-3-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 26, 2021, Peter Gonda wrote:
> To avoid exposing this internal state to userspace and prevent other
> processes from importing state they shouldn't have access to, the send
> returns a token to userspace that is handed off to the target VM. The
> target passes in this token to receive the sent state. The token is only
> valid for one-time use. Functionality on the source becomes limited
> after send has been performed. If the source is destroyed before the
> target has received, the token becomes invalid.

...

> +11. KVM_SEV_INTRA_HOST_RECEIVE
> +-------------------------------------
> +
> +The KVM_SEV_INTRA_HOST_RECEIVE command is used to transfer staged SEV
> +info to a target VM from some source VM. SEV on the target VM should be active
> +when receive is performed, but not yet launched and without any pinned memory.
> +The launch commands should be skipped after receive because they should have
> +already been performed on the source.
> +
> +Parameters (in/out): struct kvm_sev_intra_host_receive
> +
> +Returns: 0 on success, -negative on error
> +
> +::
> +
> +    struct kvm_sev_intra_host_receive {
> +        __u64 info_token;    /* token referencing the staged info */

Sorry to belatedly throw a wrench in things, but why use a token approach?  This
is only intended for migrating between two userspace VMMs using the same KVM 
module, which can access both the source and target KVM instances (VMs/guests).
Rather than indirectly communicate through a token, why not communidate directly?
Same idea as svm_vm_copy_asid_from().

The locking needs special consideration, e.g. attempting to take kvm->lock on
both the source and dest could deadlock if userspace is malicious and
double-migrates, but I think a flag and global spinlock to state that migration
is in-progress would suffice.                                                                                 

Locking aside, this would reduce the ABI to a single ioctl(), should avoid most 
if not all temporary memory allocations, and would obviate the need for patch 1 
since there's no limbo state, i.e. the encrypted regions are either owned by the
source or the dest.

I think the following would work?  Another thought would be to make the helpers
and "lock for multi-lock" flag arch-agnostic, e.g. the logic below works iff
this is the only path that takes two kvm->locks simultaneous.

static int svm_sev_lock_for_migration(struct kvm *kvm)
{
	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
	int ret = 0;

	/*
	 * Bail if this VM is already involved in a migration to avoid deadlock
	 * between two VMs trying to migrate to/from each other.
	 */
	spin_lock(&sev_migration_lock);
	if (sev->migration_in_progress)
		ret = -EINVAL;
	else
		sev->migration_in_progress = true;
	spin_unlock(&sev_migration_lock);

	if (!ret)
		mutex_lock(&kvm->lock);

	return ret;
}

static void svm_unlock_after_migration(struct kvm *kvm)
{
	mutex_unlock(&kvm->lock);
	WRITE_ONCE(sev->migration_in_progress, false);
}

int svm_sev_migrate_from(struct kvm *kvm, unsigned int source_fd)
{
	struct file *source_kvm_file;
	struct kvm *source_kvm;
	int ret = -EINVAL;

	ret = svm_sev_lock_for_migration(kvm);
	if (ret)
		return ret;

	if (!sev_guest(kvm))
		goto out_unlock;

	source_kvm_file = fget(source_fd);
	if (!file_is_kvm(source_kvm_file)) {
		ret = -EBADF;
		goto out_fput;
	}

	source_kvm = source_kvm_file->private_data;
	ret = svm_sev_lock_for_migration(source_kvm);
	if (ret)
		goto out_fput;

	if (!sev_guest(source_kvm)) {
		ret = -EINVAL;
		goto out_source;
	}

	<migration magic>

out_source:
	svm_unlock_after_migration(&source_kvm->lock);
out_fpu:
	if (source_kvm_file)
		fput(source_kvm_file);
out_unlock:
	svm_unlock_after_migration(kvm);
	return ret;
}
