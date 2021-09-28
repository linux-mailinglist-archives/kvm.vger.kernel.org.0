Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2F441AF2C
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 14:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240698AbhI1MoH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 08:44:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240637AbhI1MoF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 08:44:05 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629AAC061575;
        Tue, 28 Sep 2021 05:42:26 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id B2248208; Tue, 28 Sep 2021 14:42:24 +0200 (CEST)
Date:   Tue, 28 Sep 2021 14:42:19 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4 V8] KVM: SEV: Add support for SEV intra host migration
Message-ID: <YVMNq4wwjYZ8F7N8@8bytes.org>
References: <20210914164727.3007031-1-pgonda@google.com>
 <20210914164727.3007031-2-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914164727.3007031-2-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021 at 09:47:24AM -0700, Peter Gonda wrote:
> +static int sev_lock_vcpus_for_migration(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i, j;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (mutex_lock_killable(&vcpu->mutex))
> +			goto out_unlock;
> +	}
> +
> +	return 0;
> +
> +out_unlock:
> +	kvm_for_each_vcpu(j, vcpu, kvm) {
> +		mutex_unlock(&vcpu->mutex);
> +		if (i == j)
> +			break;

Hmm, doesn't the mutex_unlock() need to happen after the check?

