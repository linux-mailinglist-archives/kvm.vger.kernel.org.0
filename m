Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0237B1869
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 12:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbjI1KmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 06:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230511AbjI1KmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 06:42:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB0C12A
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695897675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZIL/aLxSaBTwOd49hOiCBXEkh8RfyyP05npLoIlrk4w=;
        b=JSsrrb9DDqLozWxy23DA6FikMNv4MSJJoeSjv0sDJpyAaKvJ5m9Ymx+HdFqvjyK8xtQaiZ
        aFOQyJAjsNTW+3+K+7lA1TgiEj5CBmkYUqY2XaPmq47Ecul9zfol6sNGu+H9I3lQeEYf89
        19BzVgUyjy68+0tkTrJyNCi09U6T05I=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-zvteAjWeMS-6wjcF4v6GdA-1; Thu, 28 Sep 2023 06:41:13 -0400
X-MC-Unique: zvteAjWeMS-6wjcF4v6GdA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-50433961a36so17589393e87.3
        for <kvm@vger.kernel.org>; Thu, 28 Sep 2023 03:41:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695897672; x=1696502472;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZIL/aLxSaBTwOd49hOiCBXEkh8RfyyP05npLoIlrk4w=;
        b=t6gW19T8RAtDtBiHYnoE5Zdmth97j3xVqBF+UsMEjx/BtAwazrYJnFbxViAZWEbvOb
         QHhmLP0FxlovRxEZSEMg8PVgoG4t2wky82PpEHQbYVonZYkE/Ysc1ERrYXkap+ZMHEPg
         Nuk/ssAC4OOOATW/vnJl6XlOcYDNsoeONHmjViD+BX6nQrY7mCr/PbttYiT4xFYmPguB
         UxrW1NZwlqW4IwTw6+VZGSNGcNMWMbFcx5jnABKpWwhRcoAVJLAKsR1yj0vi9ErTPA1j
         /u8Etr+YEfJcCfPmoMeWzgEbIN0M0u4fC26HGkUT9dVuQNL6T9dudmspyZ3kTTFMYI36
         sb7A==
X-Gm-Message-State: AOJu0Yz86qEHGXk6ngewq4rRcQczj1P7/9Jy52YH3CpQNp0GSMD9Ju5r
        SCb38gsc9uh1jUSdA74v8WlKtUkDcbbXbaC0DhBIMCwG57cSjicfgQRpC4sctVNPCPEcfqGNKA+
        btNbSY2qT9YYf
X-Received: by 2002:a19:7110:0:b0:502:9fce:b6da with SMTP id m16-20020a197110000000b005029fceb6damr693709lfc.21.1695897672218;
        Thu, 28 Sep 2023 03:41:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZnGFQao4JKubYwjZ1ImNhZcdEbjf0t/69AWlyueHN/65GfbbBPeP3rAa54U13dQaswEUQqg==
X-Received: by 2002:a19:7110:0:b0:502:9fce:b6da with SMTP id m16-20020a197110000000b005029fceb6damr693694lfc.21.1695897671830;
        Thu, 28 Sep 2023 03:41:11 -0700 (PDT)
Received: from starship ([89.237.96.178])
        by smtp.gmail.com with ESMTPSA id u8-20020a7bc048000000b003fe2b081661sm22518733wmc.30.2023.09.28.03.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Sep 2023 03:41:11 -0700 (PDT)
Message-ID: <c6939a0d710438c4b3d3d98fb7b81030e9d01a0f.camel@redhat.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: refactor req_immediate_exit logic
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>
Date:   Thu, 28 Sep 2023 13:41:09 +0300
In-Reply-To: <93396a36-30fe-74d6-d812-a93dafa771cb@redhat.com>
References: <20230924124410.897646-1-mlevitsk@redhat.com>
         <20230924124410.897646-2-mlevitsk@redhat.com>
         <93396a36-30fe-74d6-d812-a93dafa771cb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On 9/24/23 14:44, Maxim Levitsky wrote:
> > +	if (vcpu->arch.req_immediate_exit)
> >   		kvm_make_request(KVM_REQ_EVENT, vcpu);
> > -		static_call(kvm_x86_request_immediate_exit)(vcpu);
> > -	}
> 
> Is it enough for your use case to add a new tracepoint here, instead of 
> adding req_immediate_exit to both entry and exit?


I prefer if possible to keep the req_immediate_exit field on entry only,
as it is pretty much an extension to the injected event data which I also
added to kvm_entry() tracepoint.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 




