Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68BAE4D1630
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 12:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346179AbiCHL0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 06:26:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233551AbiCHL0w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 06:26:52 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7DC3ED25;
        Tue,  8 Mar 2022 03:25:56 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so2112813pjb.3;
        Tue, 08 Mar 2022 03:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=cy+w1mMChm1Hkz8fLvEHCL0lUwa62I5Ra7YiL5cjBo4=;
        b=lupN6ZbikkKdfRx2fUqnib3W0nHEbroqbhop9IGGa/421sZayuz4ycHxpDyz/Tfe3O
         iT6OpFuuZBSDLE3b311G3ebsGN0ecRpMrItFovoJEBV1wuINfe6813gFqHJMvX30A4DB
         ZbUjY9+YkqsTi/amivj09M+MGDenTuX+KV1irgCp20UN2ir0X3np1B6tU7fLaQcFrQAo
         MXhcwdtL0AHv6qPMiD5KedZs/9zrabHQzy8hZOsY3zqU/sQyXyOeJcgrSYnzcJ4oe+tI
         6kay5kODBp5Mo399uTbfduC75PM3dpqIjebJXddEsTqe1zfK13MHQ6byPcyxrxho2EO1
         UWFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=cy+w1mMChm1Hkz8fLvEHCL0lUwa62I5Ra7YiL5cjBo4=;
        b=EO9PxMJZThz+C5nLGNSKR4uToDFk36qhsHDtvpDj/Lde9/t/lRwpjySGO7wE5kdEHg
         7fCll24PdSgjbpNsg7G8IXNb9AydqqOfWui9M9lt7ixS70R8aCiRGSr1zRp+Fq1TGv7R
         6/U1EPYGgQohk1r8Z8km/S8LQkS6X3yuesdMeUfWjWtw/8Ps2pIgyY2/foeSiyTrCh9k
         wa6nl+crttlDxILDFSR5Z5HOjnkibE6NF+9BQ3TSgnWvZlx+ym3HQtd1EGntyuQF15iT
         tMlpS+hVswUEAJivGNl6D2td3JI1erao0bdj6oLmIaGfyxYZbJQ0S+4JIklKarfEyV4b
         JJDA==
X-Gm-Message-State: AOAM532wjkZFFPsSuiEwbuX/TNjKJRjh/04VKS8lAaUv8+OQGR5TJaY5
        fi5Iv9SwC+1Zp1FXl+ztOIs=
X-Google-Smtp-Source: ABdhPJz/hEQJZHRqB9iTQYW3NTPCyYXuHq2nb7uVTnJ5J+/3sx+SZuVPNlbvM+g96Dwe2138wzSWYA==
X-Received: by 2002:a17:90b:4a44:b0:1bf:8deb:9435 with SMTP id lb4-20020a17090b4a4400b001bf8deb9435mr2038120pjb.16.1646738755774;
        Tue, 08 Mar 2022 03:25:55 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z35-20020a631923000000b00373520fddd5sm15257262pgl.83.2022.03.08.03.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 03:25:55 -0800 (PST)
Message-ID: <158bcefb-4087-c2a3-cfcf-e33ab53af649@gmail.com>
Date:   Tue, 8 Mar 2022 19:25:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v2 12/12] KVM: x86/pmu: Clear reserved bit PERF_CTL2[43]
 for AMD erratum 1292
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
References: <20220302111334.12689-1-likexu@tencent.com>
 <20220302111334.12689-13-likexu@tencent.com>
 <CALMp9eT1N_HeipXjpyqrXs_WmBEip2vchy4d1GffpwrEd+444w@mail.gmail.com>
 <273a7631-188b-a7a9-a551-4e577dcdd8d1@gmail.com>
 <CALMp9eRM9kTxmyHr2k1r=VSjFyDy=Dyvek5gdgZ8bHHrmPL5gQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <CALMp9eRM9kTxmyHr2k1r=VSjFyDy=Dyvek5gdgZ8bHHrmPL5gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/3/2022 3:06 am, Jim Mattson wrote:
> We should continue to synthesize a #GP for an attempt to set "must be
> zero" bits or for rule violations, like "address must be canonical."

Actually, I do stand in the same position as you.

> However, we have absolutely no business making up our own hardware
> specification. This is a bug, and it should be fixed, like any other
> bug.
Current virtual hardware interfaces do not strictly comply with vendor 
specifications
and may not be the same in the first step of enablement, or some of them may have
to be compromised later out of various complexity.

The behavior of AMD's "synthesize a #GP" to "reserved without qualification" bits
is clearly a legacy tech decision (not sure if it was intentional). We may need 
a larger
independent patch set to apply this one-time surgery, including of course this 
pmu issue.

What do you think ?




