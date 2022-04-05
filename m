Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA59F4F498D
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 02:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442658AbiDEWT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 18:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392286AbiDEPgB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 11:36:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57FD113CC6
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 06:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649166514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZveUJKzsoCzkXjLEmVVwtjwhVIlnnTQ1b+zTECXTF/U=;
        b=dVWCbavWvFMQc7HfiyfFDddpFOIRTnDMtsZTC00ByyE5B1jNiOPAYLsziiRlk/INa08B8D
        f5q5ltGyHPdLzsCVIK6wYWnbxHoa29LFG/erNkx/PJ1meBvmPL5JZMoUHbs/HcYovpA3xL
        zz0Zf7YNVVgEmZbxcAykmG6xV1YXSSA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-423-sFqKeBBPNuePK-BoHgBX0Q-1; Tue, 05 Apr 2022 09:48:33 -0400
X-MC-Unique: sFqKeBBPNuePK-BoHgBX0Q-1
Received: by mail-wm1-f70.google.com with SMTP id t124-20020a1c4682000000b0038c8e8f8212so4056187wma.2
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 06:48:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZveUJKzsoCzkXjLEmVVwtjwhVIlnnTQ1b+zTECXTF/U=;
        b=45E4Sg6wRm5tLTpYmS2qrm1srxChBamXCBL2P3AC3MWFroJtDltgZKHjCVvsD1zN8D
         o2r58s1rCLZ6Sw3flczGMKdU45/iPtmjZN8QF/tE/0K6piIzd85yUfewoz0Zd6RoRatg
         RWTY+3c+6kEtw6xIp6/zMxef8uGcFe8+ct0FTseAGAzNq0j9wzyMxiu30vJnExjrSRPq
         iCnxpFbbMlZbERLLHwh6zZtWiFzl+utF4ztF7n0vykQyM0iYlGWjQutoyEcmebM4orcq
         KzqAkGWUENmizm12KhZlbD4hidV9OIpRIz1d8UzEE3y/q4k1V1cMlj3MBRHCyldGXe1g
         4Rcg==
X-Gm-Message-State: AOAM532q1X0nktVeVKSN1xDXHpRylE1ymMSGvQQOCCLvVCaKDXdmSIkh
        dvpRUeHHTNA6Ebwc3zYkhR7ULIRUz2RtnNqvkfBSoMavitPyaIZqIaCDwZUwYTXkFD6BMrOb3lN
        q6fqD3Afzm+yO
X-Received: by 2002:a7b:cd13:0:b0:38c:9a08:5c62 with SMTP id f19-20020a7bcd13000000b0038c9a085c62mr3234419wmj.154.1649166512158;
        Tue, 05 Apr 2022 06:48:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgxLrzuXmRgcHGSm9NougyOgwDnbf47hIlS2lc6czMniBzy/El5Zf8y2oTdwEa1oPyH4skoA==
X-Received: by 2002:a7b:cd13:0:b0:38c:9a08:5c62 with SMTP id f19-20020a7bcd13000000b0038c9a085c62mr3234400wmj.154.1649166511973;
        Tue, 05 Apr 2022 06:48:31 -0700 (PDT)
Received: from [10.32.181.87] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.googlemail.com with ESMTPSA id o19-20020a05600c511300b0038d0d8f67e5sm2275912wms.16.2022.04.05.06.48.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 06:48:30 -0700 (PDT)
Message-ID: <5093bff2-bc85-57b9-5f8b-ecb81417409e@redhat.com>
Date:   Tue, 5 Apr 2022 15:48:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 032/104] KVM: x86/mmu: introduce config for PRIVATE
 KVM MMU
Content-Language: en-US
To:     Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <770235e7fed04229b81c334e2477374374cea901.1646422845.git.isaku.yamahata@intel.com>
 <55fa888b31bae80bf72cbdbdf6f27401ea4ccc5c.camel@intel.com>
 <20220401015130.GE2084469@ls.amr.corp.intel.com>
 <9e01bc014df60e215ba17432c06b6854f6dae3f8.camel@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9e01bc014df60e215ba17432c06b6854f6dae3f8.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/1/22 04:13, Kai Huang wrote:
>> I don't want to use CONFIG_INTEL_TDX_HOST in KVM MMU code.  I think the change
>> to KVM MMU should be a sort of independent from TDX.  But it seems failed based
>> on your feedback.
> 
> Why do you need to use any config?  As I said majority of your changes to MMU
> are not under any config.  But I'll leave this to maintainer/reviewers.

There are few uses, but the effect should be pretty large, because the 
config symbol replaces variable accesses with constants:

+static inline gfn_t kvm_gfn_stolen_mask(struct kvm *kvm)
+{
+#ifdef CONFIG_KVM_MMU_PRIVATE
+	return kvm->arch.gfn_shared_mask;
+#else
+	return 0;
+#endif
+}

Please keep it.

Paolo

