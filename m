Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6E94CC812
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 22:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236540AbiCCVdG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 16:33:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbiCCVdD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 16:33:03 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6F8167FB8
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 13:32:17 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 9so5936640pll.6
        for <kvm@vger.kernel.org>; Thu, 03 Mar 2022 13:32:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kudP5fV+oewEgx+1iJMm74xzhJH7jghnvNdgCXLF87M=;
        b=WU0AOsFRliB/v4AOfuttxKeRS4+tgI1q1XYePYec6mV3RzgqmI/+fYoZHt3D64DlPL
         bs8fWMhYQdkWnhY67xF7DeexmT1emRNMgh/cuv8l7P0GMsBe54G/bX51p5uyNG3BLWeV
         inxEO0L4eMxKSxG/R1vRiBXoxs9OTtbnkrEQjIrsmxbr5Awf6aRUFU2krCFkmtHr2Vek
         rjLunkCaOS8Wg2ZZAP3m2fCuvhMgLXW5x5Fx17DBgSh3opC/MnSXbzR7mVF0NvRoL0Gx
         So5JZNnyvC5lmQt0G37tqTAZ9SA+6gLYaxYPsmJTXtHzqJswloCGKs2z1tyTFLG6L5x3
         huXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kudP5fV+oewEgx+1iJMm74xzhJH7jghnvNdgCXLF87M=;
        b=YFT/JRY979nJSBSM3JlIQF3Jv4ixKu3hunIZu3dD4gHhNPxnMYQNHulkpt1307nqCT
         7TNdYXMckGPy1upO+lxc3sOrAs5GXU2/UOofwZfFCIWtpvzOK8hnEHQdBSw+hugYNNOu
         tcsRuauVuB3VUDvkXOmPaxTSF6CpGAD+Jn0tACLVx2tdu2Mi8qLbk3RPWfIqNfu0oAkH
         0QBODEOqmcToPqphlwSadvkWshfVZTcQrV0wwOerpeMY9o7Il2UHbd6VCTo7LaxPvUJ2
         XM/8/sD4i7L/GAyIeFiNW2ULsKPBxeyHlPkRcJU21yPWr6yYHP1XRJaVaW7yZX7x564R
         f9KA==
X-Gm-Message-State: AOAM531RkEG40SfbQWQKeqDqKO1bTa+hFg8tV/aw09SJrG5/jk2C38lU
        rf46RuB+UYZ3enSD+HjVTiYcvw==
X-Google-Smtp-Source: ABdhPJxyEFfBgCewybrpfbsPNeL3x+7VOL/nwKb+mYI+/8GSTOWTK5HmfFVEseCW25SixBD7Kqa58w==
X-Received: by 2002:a17:902:c94e:b0:151:a988:f3dd with SMTP id i14-20020a170902c94e00b00151a988f3ddmr4508675pla.142.1646343136215;
        Thu, 03 Mar 2022 13:32:16 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id rm8-20020a17090b3ec800b001bcd57956desm2861035pjb.51.2022.03.03.13.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 13:32:15 -0800 (PST)
Date:   Thu, 3 Mar 2022 21:32:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v4 21/30] KVM: x86/mmu: Zap invalidated roots via
 asynchronous worker
Message-ID: <YiEz3D18wEn8lcEq@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-22-pbonzini@redhat.com>
 <YiExLB3O2byI4Xdu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiExLB3O2byI4Xdu@google.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022, Sean Christopherson wrote:
> On Thu, Mar 03, 2022, Paolo Bonzini wrote:
> > The only issue is that kvm_tdp_mmu_invalidate_all_roots() now assumes that
> > there is at least one reference in kvm->users_count; so if the VM is dying
> > just go through the slow path, as there is nothing to gain by using the fast
> > zapping.
> 
> This isn't actually implemented. :-)

Oh, and when you implement it (or copy paste), can you also add a lockdep and a
comment about the check being racy, but that the race is benign?  It took me a
second to realize why it's safe to use a work queue without holding a reference
to @kvm.

static void kvm_mmu_zap_all_fast(struct kvm *kvm)
{
	lockdep_assert_held(&kvm->slots_lock);

	/*
	 * Zap using the "slow" path if the VM is being destroyed.  The "slow"
	 * path isn't actually slower, it just just doesn't block vCPUs for an
	 * extended duration, which is irrelevant if the VM is dying.
	 *
	 * Note, this doesn't guarantee users_count won't go to '0' immediately
	 * after this check, but that race is benign as callers that don't hold
	 * a reference to @kvm must hold kvm_lock to prevent use-after-free.
	 */
	if (unlikely(refcount_read(&kvm->users_count)) {
		lockdep_assert_held(&kvm_lock);
		kvm_mmu_zap_all(kvm);
		return;
	}

	write_lock(&kvm->mmu_lock);
	trace_kvm_mmu_zap_all_fast(kvm);
