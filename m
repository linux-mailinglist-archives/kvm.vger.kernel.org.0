Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F17D49980D
	for <lists+kvm@lfdr.de>; Mon, 24 Jan 2022 22:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376440AbiAXVTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jan 2022 16:19:35 -0500
Received: from relay035.a.hostedemail.com ([64.99.140.35]:9254 "EHLO
        relay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1345443AbiAXVNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jan 2022 16:13:16 -0500
X-Greylist: delayed 610 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Jan 2022 16:13:16 EST
Received: from omf19.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay08.hostedemail.com (Postfix) with ESMTP id 647BB210AB;
        Mon, 24 Jan 2022 21:03:03 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf19.hostedemail.com (Postfix) with ESMTPA id D692520030;
        Mon, 24 Jan 2022 21:03:01 +0000 (UTC)
Message-ID: <864dfbfdc44e288e99cf7baa3aa8f7c8568db507.camel@perches.com>
Subject: Re: [PATCH 2/2] KVM: x86: Use memcmp in kvm_cpuid_check_equal()
From:   Joe Perches <joe@perches.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        linux-kernel@vger.kernel.org
Date:   Mon, 24 Jan 2022 13:03:00 -0800
In-Reply-To: <20220124103606.2630588-3-vkuznets@redhat.com>
References: <20220124103606.2630588-1-vkuznets@redhat.com>
         <20220124103606.2630588-3-vkuznets@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.08
X-Stat-Signature: gkdp8cdydwpxgpnnhk3gx3ocsdue6wgx
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: D692520030
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19QDOkk4WUvsKIAh9pZT26JkxbkBW5jJ9w=
X-HE-Tag: 1643058181-282243
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-01-24 at 11:36 +0100, Vitaly Kuznetsov wrote:
> kvm_cpuid_check_equal() should also check .flags equality but instead
> of adding it to the existing check, just switch to using memcmp() for
> the whole 'struct kvm_cpuid_entry2'.

Is the struct padding guaranteed to be identical ?

> 
> When .flags are not checked, kvm_cpuid_check_equal() may allow an update
> which it shouldn't but kvm_set_cpuid() does not actually update anything
> and just returns success.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/cpuid.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 89d7822a8f5b..7dd9c8f4f46e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -123,20 +123,11 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
>  static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
>  				 int nent)
>  {
> -	struct kvm_cpuid_entry2 *orig;
> -	int i;
> -
>  	if (nent != vcpu->arch.cpuid_nent)
>  		return -EINVAL;
>  
> -	for (i = 0; i < nent; i++) {
> -		orig = &vcpu->arch.cpuid_entries[i];
> -		if (e2[i].function != orig->function ||
> -		    e2[i].index != orig->index ||
> -		    e2[i].eax != orig->eax || e2[i].ebx != orig->ebx ||
> -		    e2[i].ecx != orig->ecx || e2[i].edx != orig->edx)
> -			return -EINVAL;
> -	}
> +	if (memcmp(e2, vcpu->arch.cpuid_entries, nent * sizeof(*e2)))
> +		return -EINVAL;
>  
>  	return 0;
>  }


