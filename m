Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0781770B36
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 23:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjHDVsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 17:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjHDVsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 17:48:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380B9F7
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 14:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691185632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tiScYNNF3/5tyRgaI7Wx7hPnkZAj0r8d0q062ZADxes=;
        b=VUbK4DwX9znW64y+EOWmlwZDtjEWcJiBOd+NtuxVN6KXUp0pCtCXHFXLF9mKur5JobZtSF
        V+dLQN0LTyZ25JgSM8dCbKtjuZAoRSG860GstHYjDyEQd/9LV3RwDSMUmOXcKuOQq5GyJU
        BhbTk/SKraatiVSbAw0IpL8T8PidBhI=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-yDjUypx7P96PwC69lC_Jjw-1; Fri, 04 Aug 2023 17:47:11 -0400
X-MC-Unique: yDjUypx7P96PwC69lC_Jjw-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b9bcf13746so30308641fa.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 14:47:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691185629; x=1691790429;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tiScYNNF3/5tyRgaI7Wx7hPnkZAj0r8d0q062ZADxes=;
        b=RFJvqa0R3TeX+egyjyLm1tw87SfWQI5/Q036fkluaAFz0Mu0rNI1S6cKBFshA7KEF0
         aJHdfh9Gu9jCp49lJv22nJ0YeN5o+qIFBQCkpTqNzasLyBEVNn8NWhcl/IfR6cit3rq2
         MHVkTht43EWl8Dx6a8pTkpwOzVvym6Dw3UvV99JswFIAhv8rTPCptwa2TjA52oZMkdEZ
         lr7eSNDFyFY6v4uOP66EqRtEnwh6JINFi/FN2VJEsktYSpWz6Zn6WjarfP+VWGakSjN0
         QEZgqSNqGt22WWkmsy6h3LTxxzG28+/PVrCrh3UzvhWLPilaZenRHxlVlLc6zE7EuUTu
         MJHg==
X-Gm-Message-State: AOJu0Yykx/bASY4hXKczw4xBkhdeWRA5XhD0BzI4XhvK0/NtlKsGn4qJ
        LxlByyeSvzmiXC7a2S4sTCcIGLFKpTYpPFey3y3V38HOfF4MFjZqwyfw7EH1+wQSRSBJA6ipNTv
        PcgZW9pM58LFx
X-Received: by 2002:a2e:8097:0:b0:2b6:df71:cff1 with SMTP id i23-20020a2e8097000000b002b6df71cff1mr2280549ljg.52.1691185629601;
        Fri, 04 Aug 2023 14:47:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExe5iiZfhIyXQdWvWaXrTzadO33FxB5aH81HqxqGBkNcUN8aPdMF9xEDQqQjhI1d+42Kq3fw==
X-Received: by 2002:a2e:8097:0:b0:2b6:df71:cff1 with SMTP id i23-20020a2e8097000000b002b6df71cff1mr2280541ljg.52.1691185629115;
        Fri, 04 Aug 2023 14:47:09 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id d24-20020a170906c21800b00989828a42e8sm1834839ejz.154.2023.08.04.14.47.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Aug 2023 14:47:08 -0700 (PDT)
Message-ID: <6d0b0da3-5df2-46f4-d6ba-75ae6a187483@redhat.com>
Date:   Fri, 4 Aug 2023 23:47:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v5 08/19] KVM:x86: Report KVM supported CET MSRs as
 to-be-saved
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>, seanjc@google.com,
        peterz@infradead.org, john.allen@amd.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rick.p.edgecombe@intel.com, chao.gao@intel.com,
        binbin.wu@linux.intel.com
References: <20230803042732.88515-1-weijiang.yang@intel.com>
 <20230803042732.88515-9-weijiang.yang@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20230803042732.88515-9-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/3/23 06:27, Yang Weijiang wrote:
> Add all CET MSRs including the synthesized GUEST_SSP to report list.
> PL{0,1,2}_SSP are independent to host XSAVE management with later
> patches. MSR_IA32_U_CET and MSR_IA32_PL3_SSP are XSAVE-managed on
> host side. MSR_IA32_S_CET/MSR_IA32_INT_SSP_TAB/MSR_KVM_GUEST_SSP
> are not XSAVE-managed.

MSR_KVM_GUEST_SSP -> MSR_KVM_SSP

Also please add a comment,

/*
  * SSP can only be read via RDSSP; writing even requires
  * destructive and potentially faulting operations such as
  * SAVEPREVSSP/RSTORSSP or SETSSBSY/CLRSSBSY.  Let the host
  * use a pseudo-MSR that is just a wrapper for the GUEST_SSP
  * field of the VMCS.
  */

Paolo

