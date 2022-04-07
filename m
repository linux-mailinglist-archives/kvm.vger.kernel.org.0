Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666FB4F8112
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 15:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbiDGN6H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 09:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiDGN6G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 09:58:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9349A101F2A
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 06:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649339765;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OFruv6SyU3k5Tp2Auo/lsfT5rYjkA30i4CwmN00PmTI=;
        b=DUpCdPXR7HOxkeWBt+5xI9WPn947njGdmtGRNCXrCY1T7QXuko+2Nxx6vwIRwuc7IGLx5U
        Ogd5atEQIp09uV/y9uKU8Nykk2hODdiwV9LbYAb2gmlZ52BxiAnPkSs5A8tM+FIsaipxp3
        EXgtQ97sRf91FkdSMcZS+Cuq4qKlC5g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-Yls0Z2c3MrGthLM3LvqcMQ-1; Thu, 07 Apr 2022 09:56:04 -0400
X-MC-Unique: Yls0Z2c3MrGthLM3LvqcMQ-1
Received: by mail-ed1-f70.google.com with SMTP id m23-20020a056402051700b0041cd56be44cso2997759edv.10
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 06:56:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=OFruv6SyU3k5Tp2Auo/lsfT5rYjkA30i4CwmN00PmTI=;
        b=i3oDPUaE+2Chd9+SROT79v/cFcOrxOWp+xKftIgccTg13YaS6hIAbWEGGotWMSm5Ul
         TcIPI+v16GiW/zFqBDzCpvwuErJUimRK8ascOEhcvuyQINNrcMakA5evLh2F1E8Uruc5
         N4J0Peg/oWB79PVlPiJsjzv5SrgG4WXxVR3wIcAWqX6N+Mvdos3Da5R6/Co+b2tv+LYA
         ntUyTCyCcJpBbrtrbEJcNva1dfaeDXsKrvme9a2UV3WnUUrePt3nhcRbpm4WXP4/7PAj
         lvA7JwDQGiCYMbn65PyKgj4LbGNF7WjpnWVU/mRRY+lRA/L1ehyt3LMhm+fYoo7dlMPc
         QgaQ==
X-Gm-Message-State: AOAM530T2+qpJzlyJt+QZOnIIFeYFqDCk7qYkJcB17Ex+mMhXWzJfYSS
        BgnvlEDWk974sfEwM27I82izzfFXiKuyBjpIEhF+aXa0POP1a4WGK7ZQtp/vl+HYtxKh5nVO2df
        sdV4THiwX9YEs
X-Received: by 2002:a17:907:a088:b0:6e4:dad7:1b1f with SMTP id hu8-20020a170907a08800b006e4dad71b1fmr13211417ejc.84.1649339763216;
        Thu, 07 Apr 2022 06:56:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxvEebQwCcSzhV0JO4ajmv0FCub5YVkIXuEm7bLi5rM8dJZlY9eZrBUjnM5yQHK497ox/1eKA==
X-Received: by 2002:a17:907:a088:b0:6e4:dad7:1b1f with SMTP id hu8-20020a170907a08800b006e4dad71b1fmr13211393ejc.84.1649339762999;
        Thu, 07 Apr 2022 06:56:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id j24-20020a170906255800b006e7f44d46fesm4255745ejb.222.2022.04.07.06.56.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 06:56:02 -0700 (PDT)
Message-ID: <282d4cd1-d1f7-663c-a965-af587f77ee5a@redhat.com>
Date:   Thu, 7 Apr 2022 15:56:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 092/104] KVM: TDX: Handle TDX PV HLT hypercall
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <6da55adb2ddb6f287ebd46aad02cfaaac2088415.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> +	bool interrupt_disabled = tdvmcall_p1_read(vcpu);

Where is R12 documented for TDG.VP.VMCALL<Instruction.HLT>?

> +		 * Virtual interrupt can arrive after TDG.VM.VMCALL<HLT> during
> +		 * the TDX module executing.  On the other hand, KVM doesn't
> +		 * know if vcpu was executing in the guest TD or the TDX module.

I don't understand this; why isn't it enough to check PI.ON or something 
like that as part of HLT emulation?

> +		details.full = td_state_non_arch_read64(
> +			to_tdx(vcpu), TD_VCPU_STATE_DETAILS_NON_ARCH);

TDX documentation says "the meaning of the field may change with Intel 
TDX module version", where is this field documented?  I cannot find any 
"other guest state" fields in the TDX documentation.

Paolo

> +		if (details.vmxip)
> +			return 1;
> +	}
> +
> +	return kvm_emulate_halt_noskip(vcpu);

