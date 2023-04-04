Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5B56D69BE
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 19:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235215AbjDDREp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 13:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbjDDREl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 13:04:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF2AE69
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680627832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E8sSDVvxyvnOruB+0lVJW1HHgkW7ZReKHR1WtAZfwmo=;
        b=UCpc+PfznrOWzF0a2DefJwzW3tDE45SHSUUIY/mS3mlSyuhfPDKhFk1AmFAz/xUWNxE+S1
        S/W1OJuQxtjLaE6cFjma84anxTgGzsw8CutZXDIZCEBRSWx73LEhauNMr24rx39euT/ECf
        iHoFN3H5XxFbsDgsli92oFvHeUwLgyw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-1mqNPdZiO1KxVL4_sfVjyw-1; Tue, 04 Apr 2023 13:03:50 -0400
X-MC-Unique: 1mqNPdZiO1KxVL4_sfVjyw-1
Received: by mail-ed1-f70.google.com with SMTP id m18-20020a50d7d2000000b00501dfd867a4so47385610edj.20
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 10:03:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627828; x=1683219828;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E8sSDVvxyvnOruB+0lVJW1HHgkW7ZReKHR1WtAZfwmo=;
        b=q+zeLLmSYdevB/OIBNaRtEnmmU1HLJtRx50A56SSdUrO6YM9iFiI7IFNLVpC4t53cF
         /WqXaVpBTFiN0F0L1xXj1s7bnjunSMQn0r4Lur01VBhFdlFuUrHp1+3Ki/AkaWANZnOL
         duHkIjY0ko8Y68y01xbuPwHtxbwf72IJEOlUjzqUoV5TfGLh3DiiwVacr6wpmljPAaNb
         E86c4j3hLX1B8r+rubfvK+E8HwF2qYsprVe2BxfQZrcnFs77u8nnXkTkKA0d36S3qzY1
         TeF4YZAgOC45eYciimyy2ExOs/wX+8p6yVw1BqW3VIyDg+Emq2WsIXELyr7DOT0rFF0N
         OxUQ==
X-Gm-Message-State: AAQBX9e9UwT3srWkGWAhw0aRpqBH+eqKvI6pESHY9IlmuMIY2T7B79Hu
        Vl0HipyOWSuK+j5NWJbhTcyO5ccEDTtez3Fk/tgbDQBRyxYKYaeuFnPTxTbTIZ5E33PE8Oyp776
        XQUV2fDO8I3a9
X-Received: by 2002:a17:906:360e:b0:931:ce20:db8e with SMTP id q14-20020a170906360e00b00931ce20db8emr222835ejb.51.1680627828514;
        Tue, 04 Apr 2023 10:03:48 -0700 (PDT)
X-Google-Smtp-Source: AKy350aFFDO02CFOBCMJ38oBbcfDo2OcrnEUu9Q6JgQdWEtobOV1hRzKF0iFO6xz/n2FBierAH2GMA==
X-Received: by 2002:a17:906:360e:b0:931:ce20:db8e with SMTP id q14-20020a170906360e00b00931ce20db8emr222810ejb.51.1680627828194;
        Tue, 04 Apr 2023 10:03:48 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j10-20020a17090643ca00b0092f38a6d082sm6128661ejn.209.2023.04.04.10.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 10:03:47 -0700 (PDT)
Message-ID: <3591487f-96ae-3ab7-6ce7-e524a070c9e7@redhat.com>
Date:   Tue, 4 Apr 2023 19:03:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [RFC PATCH 0/7] x86/entry: Atomic statck switching for IST
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Cfir Cohen <cfir@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Kaplan <David.Kaplan@amd.com>,
        David Rientjes <rientjes@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Jiri Slaby <jslaby@suse.cz>, Joerg Roedel <joro@8bytes.org>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan <knsathya@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Stunes <mstunes@vmware.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Raj Ashok <ashok.raj@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, x86@kernel.org
References: <20230403140605.540512-1-jiangshanlai@gmail.com>
 <19035c40-e756-6efd-1c02-b09109fb44c1@intel.com>
 <CAJhGHyBHmC=UXr88GsykO9eUeqJZp59jrCH3ngkFiCxVBW2F3g@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAJhGHyBHmC=UXr88GsykO9eUeqJZp59jrCH3ngkFiCxVBW2F3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/23 05:17, Lai Jiangshan wrote:
> The cover letter has 800+ lines of comments.  About 100-300 lines
> of comments will be moved into the code which would make the diffstat
> not so appealing.

Removing assembly from arch/x86/entry/ and adding English to 
Documentation/?  That's _even more_ appealing. :)

Paolo

