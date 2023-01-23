Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9388678265
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 17:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbjAWQ6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 11:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232616AbjAWQ6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 11:58:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C4F2CC42
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 08:57:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674493052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+XA503S1exeXgoY0ZbUoJZVr1Z22g+QUdlU038UUBZw=;
        b=ILD+pIxIIEjvso1aCOK73agZPFaEGUtpJ6P4Sk4u9NlATTJPgsqE+xLgtskfm/hySiPYS7
        1cSKrxuFOfNtU0Gt5KLPghMJ1BB3bQrSMz95iiNNd95HHUsNf5E/twqE25CJT9Ica7+++I
        lT+l6Aa/96UMeuMqnBd2v/N/gqk0OgA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-557-MspJI9o_NZuHz_iN3g7wOA-1; Mon, 23 Jan 2023 11:57:31 -0500
X-MC-Unique: MspJI9o_NZuHz_iN3g7wOA-1
Received: by mail-qv1-f72.google.com with SMTP id nk14-20020a056214350e00b0053472f03fedso6207763qvb.17
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 08:57:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+XA503S1exeXgoY0ZbUoJZVr1Z22g+QUdlU038UUBZw=;
        b=WUJ0Jw8+/7YK6YB/yrRLM0ZU+yftHaShZhlyVwG1Zrn6cKuunpuztIZlf95ACCjEnn
         9/dEkEDBjceceFbPwcXDgmAMgvmd1HTGidMhNDOJfjWtm1X7hjDaF0XXBP8jLWEPzZXx
         bUdB6oFXZLuRT3mmAVeG1qf4RbMMC6gulTg4NJF0gWn6yeP8Jsfwl6/W9DgaV+GLCcVj
         TzjoDrMEdSCpxIiGAueNZs8wBnFJxhPhBOiOvWuzooiQdmvwKLzL5OX61qsVDdwTtWdp
         gB456vVMH0q39ZiaS0TduvhgsE3Hfex+a9tYmMYw85GIH1E1vv6/4CtQvF28DDRMMzY0
         k7tA==
X-Gm-Message-State: AFqh2kowSFv81+Po/cHMQF6Io6r1xIGb6bFjq0c0e8qsgUDFw67O2VT6
        TrRltQmYdLjEeoLvyKN3FZ1sw+hFBO4Kyd9EV1oRvrZEUoJL/3rIirTIMycFrMUb4TH+3PToSxG
        RXl4fpMDbjrX4
X-Received: by 2002:ac8:660a:0:b0:3b6:35a4:b107 with SMTP id c10-20020ac8660a000000b003b635a4b107mr39323912qtp.5.1674493050631;
        Mon, 23 Jan 2023 08:57:30 -0800 (PST)
X-Google-Smtp-Source: AMrXdXudNjOn/1INtbMRVc24sckFkCk8FBktLD1WSAI+qrRd6zyeHXrsiwdOO+eD0hHR3X0rlkuPeA==
X-Received: by 2002:ac8:660a:0:b0:3b6:35a4:b107 with SMTP id c10-20020ac8660a000000b003b635a4b107mr39323858qtp.5.1674493050037;
        Mon, 23 Jan 2023 08:57:30 -0800 (PST)
Received: from ovpn-194-126.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x7-20020ac84d47000000b003b2957fb45bsm15759188qtv.8.2023.01.23.08.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 08:57:29 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Alexandru Matei <alexandru.matei@uipath.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>
Subject: Re: [PATCH v2] KVM: VMX: Fix crash due to uninitialized current_vmcs
In-Reply-To: <Y86vPo7vcKm9VBD8@google.com>
References: <20230123124641.4138-1-alexandru.matei@uipath.com>
 <87edrlcrk1.fsf@ovpn-194-126.brq.redhat.com>
 <e591f716-cc3b-a997-95a0-dc02c688c8ec@uipath.com>
 <Y86uaYL2JOPxMzn/@google.com> <Y86vPo7vcKm9VBD8@google.com>
Date:   Mon, 23 Jan 2023 17:57:26 +0100
Message-ID: <87bkmpchop.fsf@ovpn-194-126.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> On Mon, Jan 23, 2023, Sean Christopherson wrote:
>> On Mon, Jan 23, 2023, Alexandru Matei wrote:
>> > > .. or, alternatively, you can directly pass 
>> > > (struct hv_enlightened_vmcs *)vmx->vmcs01.vmcs as e.g. 'current_evmcs'
>> > > and avoid the conversion here.
>> > 
>> > OK, sounds good, I'll pass hv_enlightened_vmcs * directly.
>> 
>> Passing the eVMCS is silly, if we're going to bleed eVMCS details into vmx.c then
>> we should just commit and expose all details.  For this feature specifically, KVM
>> already handles the enabling in vmx.c / vmx_vcpu_create():
>> 
>> 	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs) &&
>> 	    (ms_hyperv.nested_features & HV_X64_NESTED_MSR_BITMAP)) {
>> 		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
>> 
>> 		evmcs->hv_enlightenments_control.msr_bitmap = 1;
>> 	}
>> 
>> And if we handle this fully in vmx_msr_bitmap_l01_changed(), then there's no need
>> for a comment explaining that the feature is only enabled for vmcs01.
>
> Oh, and the sanity check on a null pointer also goes away.
>
>> If we want to maintain better separate between VMX and Hyper-V code, then just make
>> the helper non-inline in hyperv.c, modifying MSR bitmaps will never be a hot path
>> for any sane guest.
>> 
>> I don't think I have a strong preference either way.  In a perfect world we'd keep
>> Hyper-V code separate, but practically speaking I think trying to move everything
>> into hyperv.c would result in far too many stubs and some weird function names.
>> 
>> Side topic, we should really have a wrapper for static_branch_unlikely(&enable_evmcs)
>> so that the static key can be defined iff CONFIG_HYPERV=y.  I'll send a patch.
>
> I.e.
>
> ---
>  arch/x86/kvm/vmx/hyperv.h | 11 -----------
>  arch/x86/kvm/vmx/vmx.c    |  9 +++++++--
>  2 files changed, 7 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
> index ab08a9b9ab7d..bac614e40078 100644
> --- a/arch/x86/kvm/vmx/hyperv.h
> +++ b/arch/x86/kvm/vmx/hyperv.h
> @@ -250,16 +250,6 @@ static inline u16 evmcs_read16(unsigned long field)
>  	return *(u16 *)((char *)current_evmcs + offset);
>  }
>  
> -static inline void evmcs_touch_msr_bitmap(void)
> -{
> -	if (unlikely(!current_evmcs))
> -		return;
> -
> -	if (current_evmcs->hv_enlightenments_control.msr_bitmap)
> -		current_evmcs->hv_clean_fields &=
> -			~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
> -}
> -
>  static inline void evmcs_load(u64 phys_addr)
>  {
>  	struct hv_vp_assist_page *vp_ap =
> @@ -280,7 +270,6 @@ static inline u64 evmcs_read64(unsigned long field) { return 0; }
>  static inline u32 evmcs_read32(unsigned long field) { return 0; }
>  static inline u16 evmcs_read16(unsigned long field) { return 0; }
>  static inline void evmcs_load(u64 phys_addr) {}
> -static inline void evmcs_touch_msr_bitmap(void) {}
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
>  #define EVMPTR_INVALID (-1ULL)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c788aa382611..ed4051b54412 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3936,8 +3936,13 @@ static void vmx_msr_bitmap_l01_changed(struct vcpu_vmx *vmx)
>  	 * 'Enlightened MSR Bitmap' feature L0 needs to know that MSR
>  	 * bitmap has changed.
>  	 */
> -	if (static_branch_unlikely(&enable_evmcs))
> -		evmcs_touch_msr_bitmap();
> +	if (IS_ENABLED(CONFIG_HYPERV) && static_branch_unlikely(&enable_evmcs)) {
> +		struct hv_enlightened_vmcs *evmcs = (void *)vmx->vmcs01.vmcs;
> +
> +		if (evmcs->hv_enlightenments_control.msr_bitmap)
> +			evmcs->hv_clean_fields &=
> +				~HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP;
> +	}

With only one evmcs_touch_msr_bitmap() user in the tree, I think such
mixing of VMX and eVMCS is fine but honestly I like Alexandru's v3 more
as the "struct hv_enlightened_vmcs *" cast is the only thing which
"leaks" into VMX. Either way, no big deal)

>  
>  	vmx->nested.force_msr_bitmap_recalc = true;
>  }
>
> base-commit: 68bfbbf518a25856c2a3f07ea9d0c626f1b001fb

-- 
Vitaly

