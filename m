Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946AB52D23F
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 14:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbiESMPI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 08:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237804AbiESMOv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 08:14:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1D78BBA565
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 05:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652962488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aRBcedztDVErkTvap/GROtONAbxkQWp2teij5HtPU3s=;
        b=d2WNs2Y6Hpfhe6/IyjEmNTE6SQsK9wlnw4qDH0WaOYR+i4sOoksTjBv0Z6YySWKg2tdJPb
        2e3xm7/C4LLobMsZnsnr3iIo60MXisxQa0BaAczmhAwq2pty6bTKiV34FU8GpeMOOzhi7G
        DPAZPbrldmXtVPDBzei8maW5vZtpzoc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-Yhd_S9tvOV2f6Zi3SFEodw-1; Thu, 19 May 2022 08:14:47 -0400
X-MC-Unique: Yhd_S9tvOV2f6Zi3SFEodw-1
Received: by mail-wr1-f69.google.com with SMTP id s14-20020adfa28e000000b0020ac7532f08so1494574wra.15
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 05:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aRBcedztDVErkTvap/GROtONAbxkQWp2teij5HtPU3s=;
        b=e49GBLD19aElZVKuBuSA8uPhtbmeTBUNs3+oJ9rvLqP5gpivV002hIksPgf6x5gk2c
         R+IKMseDhZ3rzPfD5iTpJwT+Di/JqQM7XxBIOD28voVByS3/UQVXA33IkFrWXUFnWQvQ
         1DSk2+aCguoT8m8vQUKK3JUZ79rsKljTkoFUA/HbfS6IL7zOwhV5jBzYYnlI1lDc1QVk
         08Hynj/DxqozTo0lffXSiaIfsj4imsKS7tAZfsX6EoVc+oSBrjUFLDhMDSTo233OpjOG
         ZDP8L1CoA6jsQpqlsz06Z817BPz5NwyRk1jHeg/HNYXQH+lqHygbsMcKK6lri29bSYor
         0VVg==
X-Gm-Message-State: AOAM5333Nn3/IlJ/2teq5Wr4ABj83duO2FWp/hVuOPecyec6rurhq3Cp
        nu08stGjJmNHojeY+FRwoIDut8v11jlFMRkdr4/j4ho/yBul+6p0hMOPfFrh5SEv1ODr4DYAEwL
        w2Tf0EOF1dAj/
X-Received: by 2002:a5d:644e:0:b0:20e:7267:9ef7 with SMTP id d14-20020a5d644e000000b0020e72679ef7mr753026wrw.520.1652962485995;
        Thu, 19 May 2022 05:14:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzc+tWUUsH9tzuVJImbGkhJ0Ej3I7mAxCSsBZ31dKE1NnaH+Ud9Wbb8jH/BhjS13pLD1tIPoQ==
X-Received: by 2002:a5d:644e:0:b0:20e:7267:9ef7 with SMTP id d14-20020a5d644e000000b0020e72679ef7mr753012wrw.520.1652962485831;
        Thu, 19 May 2022 05:14:45 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e17-20020a05600c255100b0039734037303sm483830wma.38.2022.05.19.05.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 05:14:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH RESEND v12 00/17] KVM: x86/pmu: Add basic support to
 enable guest PEBS via DS
In-Reply-To: <20220411101946.20262-1-likexu@tencent.com>
References: <20220411101946.20262-1-likexu@tencent.com>
Date:   Thu, 19 May 2022 14:14:43 +0200
Message-ID: <87fsl5u3bg.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Like Xu <like.xu.linux@gmail.com> writes:

...

Hi, the following commit

>   KVM: x86/pmu: Add IA32_PEBS_ENABLE MSR emulation for extended PEBS

(currently in kvm/queue) breaks a number of selftests, e.g.:

# ./tools/testing/selftests/kvm/x86_64/state_test 
==== Test Assertion Failure ====
  lib/x86_64/processor.c:1207: r == nmsrs
  pid=6702 tid=6702 errno=7 - Argument list too long
     1	0x000000000040da11: vcpu_save_state at processor.c:1207 (discriminator 4)
     2	0x00000000004024e5: main at state_test.c:209 (discriminator 6)
     3	0x00007f9f48c2d55f: ?? ??:0
     4	0x00007f9f48c2d60b: ?? ??:0
     5	0x00000000004026d4: _start at ??:?
  Unexpected result from KVM_GET_MSRS, r: 29 (failed MSR was 0x3f1)

I don't think any of these failing tests care about MSR_IA32_PEBS_ENABLE
in particular, they're just trying to do KVM_GET_MSRS/KVM_SET_MSRS.

-- 
Vitaly

