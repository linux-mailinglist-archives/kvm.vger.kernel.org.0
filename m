Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28F36549B3A
	for <lists+kvm@lfdr.de>; Mon, 13 Jun 2022 20:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245123AbiFMSPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 14:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239904AbiFMSOw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 14:14:52 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EE5985B5
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 07:09:44 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d13so5167750plh.13
        for <kvm@vger.kernel.org>; Mon, 13 Jun 2022 07:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h45d/U/M29ku8Z+G7RjVs2R1LY0TLFzhv/m4QOs4IU0=;
        b=MNmTIdaBdvI7XatwRTiFZmRQi1v3dLfiisbLNnKjpPMSAJGY/QMAMeQqVvVQedUxa3
         iXDTIrDxLRViNHfUDOVmJbABJLFuhLghXJAORWnHvvixEwBBHVdXRPHv0wqyJ0FHqQ9y
         l9NpVnK9/qwh9f1+vRjsaaT+xt+cg7eqnh0bziM8J5MV561IpHpx5CUrqEKX5RGUq6/w
         6Kc0UVIoDq2ENd2GD/vW0oc2pDO8mmkuH0Bc8n9QhBtkhXSdRX72AX2kZ2bSP8c/rQ+U
         SMsMfe6F6bUfSXu6um9HNmO1YRbARO2hYdyn4gK9dlmw6bVhCQXe/ekwgvJ//3DA2+/y
         SrVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h45d/U/M29ku8Z+G7RjVs2R1LY0TLFzhv/m4QOs4IU0=;
        b=h5A/t1NuLxqlPQpB3g6quDyjM3JwkcuPyKvq6b2pbBUJUOtUDF3nDvAXgKZievsqWG
         q75Xqs0ZFhhdiPbK6E2xt9VF66k1ksY5j8KJUliNOXd6gc0wJPkakyqKdIxDe4e2VeH0
         JiceRB3VVAHvngY5SEfNlbk+8iYoptO+9+0YCaLJSzXeyLet0cpZgaAFAobjmygLE4QK
         kbvmyLOy28kLiBuSZB87EEpPGgsqqSscEULWnwfrIelAVoJ10IwJenZCQ9VWm5vrDOvZ
         deALIdBrF6gWpGY8FgmtiQ4JrEujPmnPOPmGC5/17yh/6HlBlUs9QIfVH1bwqXtqTY1x
         S5kg==
X-Gm-Message-State: AOAM5319g8Cba+kMXUKyy5DAnqDDgr+PoQi+qak9h6LA6V4IbhhYfQJC
        0f+p8BtxwWB6ae3penIVpnnbzesPAr09Sg==
X-Google-Smtp-Source: ABdhPJwRlHQgf29lt8TLiWwmXZoGd4ZR5dDQdZp4UdXuhuQ/NnisD5WWCZmIGtyuBa+B+VxEL/M6Ug==
X-Received: by 2002:a17:90b:3a90:b0:1e6:a203:c7dd with SMTP id om16-20020a17090b3a9000b001e6a203c7ddmr16319472pjb.144.1655129383224;
        Mon, 13 Jun 2022 07:09:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v3-20020aa799c3000000b0051bc538baadsm5402039pfi.184.2022.06.13.07.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 07:09:42 -0700 (PDT)
Date:   Mon, 13 Jun 2022 14:09:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: Re: [PATCH 6/7] KVM: x86: Ignore benign host accesses to
 "unsupported" PEBS and BTS MSRs
Message-ID: <YqdFIilui+0ji+WZ@google.com>
References: <20220611005755.753273-1-seanjc@google.com>
 <20220611005755.753273-7-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611005755.753273-7-seanjc@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Jun 11, 2022, Sean Christopherson wrote:
> @@ -4122,6 +4132,16 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>  		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
>  		break;
>  #endif
> +	case MSR_IA32_PEBS_ENABLE:
> +	case MSR_IA32_DS_AREA:
> +	case MSR_PEBS_DATA_CFG:
> +		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
> +			return kvm_pmu_get_msr(vcpu, msr_info);
> +		/*
> +		 * Userspace is allowed to read MSRs that KVM reports as
> +		 * to-be-saved, even if an MSR isn't fully supported.
> +		 */
> +		return !msr_info->host_initiated;

Gah, this needs to set msr_info->data.

		/*
		 * Userspace is allowed to read MSRs that KVM reports as
		 * to-be-saved, even if an MSR isn't fully supported.
		 */
		if (!msr_info->host_initiated)
			return 1;

		msr_info->data = 0;

>  	default:
>  		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>  			return kvm_pmu_get_msr(vcpu, msr_info);
> -- 
> 2.36.1.476.g0c4daa206d-goog
> 
