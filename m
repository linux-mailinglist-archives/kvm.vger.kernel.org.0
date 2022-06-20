Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBD6551F9D
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 17:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241975AbiFTPCI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 11:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240792AbiFTPBk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 11:01:40 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EDA20182;
        Mon, 20 Jun 2022 07:29:42 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e25so11071553wrc.13;
        Mon, 20 Jun 2022 07:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cGgBS2uDbSefMyYhaKgxH8+vsRuhCSOfmf5Gh6K/Kz4=;
        b=pMub9SmSIR/Qt/2NpE/yWgATpZNmnhYhNRsUAKMb0VsEUhQ9TeGIsJOKjxTWCNWMzg
         kwbuk5qHOW01JdvW3a2Uzchbvx2On+axpWl/gJx1vyymtNpXj+nduztom3tjudPxyG2P
         x9nZ1DZ2TORzrwzRLn7b958lQkdaXyRgDcOjnPRAFlmtg279QYZu42DRjdumf1FpqnTC
         lMgz5Aa4rNYbkJO+//LKDE/wAd6OF3wOcMdt2kDBsfcjyi59XGo3HAq8YhlNe/IQkv5W
         iHZMZPAQzGNh7ezzFuhXXtN7pZulmDDl3Ti0Ydzw11HLqDGLySLq5Y58p1SQAKEjbx2c
         z4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cGgBS2uDbSefMyYhaKgxH8+vsRuhCSOfmf5Gh6K/Kz4=;
        b=SOVBWEGzPEkCph2P3yjryYhpef66VPYn9FEF0SmFLP0MA0XEX17yVJNPMOQ/ujy5oc
         ntE6bu+tkihqlVv15GNwrOHxsz5JpLhbxksa3FVd2Falbwqnrj4/lWfPm5vjyZ6lrs3J
         zgv1a+L3CZIAR0q/XcJnyPBRp1MYMBrEaSP86JTxd8C8j/BRAhwBWQzNO6CeKFNl0D/P
         sG8LklwTTheeRGzbt+orZvC4XiLc+dTMfm72rVSEjUi/bpR+IS6KLEUixvhp/Jb28y5Y
         aBtGY81pjts2kYT2dJp8lV8XAKl9kwvBewDz/YdCDN92kM3IdlMszY72oe5OtIl4epDc
         b/pg==
X-Gm-Message-State: AJIora9pgepRz8MJ2UcKOfkn93LeD6QnA4iGk5lIQQMEPX3bhDtrD2jC
        oTRAsSA1lJgJU6D29YgdNho=
X-Google-Smtp-Source: AGRyM1v//ix12t5zFYBJktov5584oQfdRGnD6ldDdATXUHbzjxTPUWl1ppZ0p9ORSMmY6kD3S0ziRQ==
X-Received: by 2002:a05:6000:1e1c:b0:21b:8a12:acba with SMTP id bj28-20020a0560001e1c00b0021b8a12acbamr9056026wrb.710.1655735380796;
        Mon, 20 Jun 2022 07:29:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id u12-20020a05600c19cc00b0039c4e2ff7cfsm19492945wmq.43.2022.06.20.07.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jun 2022 07:29:40 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <28a8dbbd-b917-bbe4-2480-d241f0b90533@redhat.com>
Date:   Mon, 20 Jun 2022 16:29:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 6/7] KVM: x86: Ignore benign host accesses to
 "unsupported" PEBS and BTS MSRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
References: <20220611005755.753273-1-seanjc@google.com>
 <20220611005755.753273-7-seanjc@google.com> <YqdFIilui+0ji+WZ@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YqdFIilui+0ji+WZ@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/13/22 16:09, Sean Christopherson wrote:
> On Sat, Jun 11, 2022, Sean Christopherson wrote:
>> @@ -4122,6 +4132,16 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
>>   		break;
>>   #endif
>> +	case MSR_IA32_PEBS_ENABLE:
>> +	case MSR_IA32_DS_AREA:
>> +	case MSR_PEBS_DATA_CFG:
>> +		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
>> +			return kvm_pmu_get_msr(vcpu, msr_info);
>> +		/*
>> +		 * Userspace is allowed to read MSRs that KVM reports as
>> +		 * to-be-saved, even if an MSR isn't fully supported.
>> +		 */
>> +		return !msr_info->host_initiated;
> 
> Gah, this needs to set msr_info->data.

Might also reuse the F15H case:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 70364d40e3f7..be39968149e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3877,9 +3877,16 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, 
struct msr_data *msr_info)
  	case MSR_DRAM_ENERGY_STATUS:	/* DRAM controller */
  		msr_info->data = 0;
  		break;
+	case MSR_IA32_PEBS_ENABLE:
+	case MSR_IA32_DS_AREA:
+	case MSR_PEBS_DATA_CFG:
  	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
  		if (kvm_pmu_is_valid_msr(vcpu, msr_info->index))
  			return kvm_pmu_get_msr(vcpu, msr_info);
+		/*
+		 * Userspace is allowed to read MSRs that KVM reports as
+		 * to-be-saved, even if an MSR isn't fully supported.
+		 */
  		if (!msr_info->host_initiated)
  			return 1;
  		msr_info->data = 0;


Paolo
