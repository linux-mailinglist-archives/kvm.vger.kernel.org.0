Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB90559EB8
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 18:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiFXQlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 12:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbiFXQlo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 12:41:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E05F552E48
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 09:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656088903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t/smxZEQF0rlrINP54p9ZMkprKgJw4xyF6tUA17beEk=;
        b=aVG7IHSNwRPL7RJUnsN4DYsoEuAYab5Tl+5Yq1kyj39CQYShl/uQVS9lOB20y8rT+6UIbW
        ebgwsmCKgLxa/sR9R935IAGiLE48H37LIYfHskGeleJaL0Pf8pBUslEBL48t4akEJvZwkA
        BlMArX+tVxLaIrHrpC8Z5q+b8pbRalY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-44-ZsvJSVyxPGGYhZOqCT9BOA-1; Fri, 24 Jun 2022 12:41:41 -0400
X-MC-Unique: ZsvJSVyxPGGYhZOqCT9BOA-1
Received: by mail-ed1-f72.google.com with SMTP id n8-20020a05640205c800b00434fb0c150cso2179712edx.19
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 09:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=t/smxZEQF0rlrINP54p9ZMkprKgJw4xyF6tUA17beEk=;
        b=6Kxxlhkffu0IoqE0arurWaDJ4az88fv061k9q+olMmTYlhGXSo1NTkYdH3AG1oqM5d
         fleWAN/zUjjgsM1VtLGDzPsqjMWs1AjbxpLvObZrkY6cmWTpW1PjwrpN/IzH5YlOW5GJ
         86+k0jKn21daoq1g91A3gN6fZXLHMdDpPE4r3OaXnLDKYUnRCBkj4bfpqriYKOx1tkoD
         FVGL5AHxJel8HNLQ1qJ1PZ6Ka2J6gQ9Vz3lFqCnK7BdFiY7EiJXohPtLKsMic0n+rz9W
         VSebz+rmOr7xBolYvCGIRvUmtfBRvtOeK8kKaadHPPCWHzD7vaYRJ7ewym3NRl4Gf7+w
         IpNA==
X-Gm-Message-State: AJIora/TBY9wCyTQ6tkBbGCBc2PRje9EWL8BrUmNEmcYyeE8MIB7rAnO
        4CfYp/nlFe9UqUxA1Zw5/D93fs8glRpJe+P7gpB6hR2dvOks/+KzCR+eZ1+eCouLmRdIAZbYOSG
        0p2DsfnBW5UZg
X-Received: by 2002:a05:6402:3707:b0:437:61f9:57a9 with SMTP id ek7-20020a056402370700b0043761f957a9mr2892431edb.1.1656088900709;
        Fri, 24 Jun 2022 09:41:40 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sAHyieuKfgfF7xh3Bu0JCOHWMglxujHSYQjWb6iC7JSljzlAJM8HrCC5MS9mk5P6odIu8b4g==
X-Received: by 2002:a05:6402:3707:b0:437:61f9:57a9 with SMTP id ek7-20020a056402370700b0043761f957a9mr2892407edb.1.1656088900517;
        Fri, 24 Jun 2022 09:41:40 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id bq15-20020a056402214f00b00435a742e350sm2451592edb.75.2022.06.24.09.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jun 2022 09:41:39 -0700 (PDT)
Message-ID: <b8610296-6fb7-e110-900f-4616e1e39bb4@redhat.com>
Date:   Fri, 24 Jun 2022 18:41:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220519102709.24125-1-suravee.suthikulpanit@amd.com>
 <20220519102709.24125-16-suravee.suthikulpanit@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 15/17] KVM: SVM: Use target APIC ID to complete x2AVIC
 IRQs when possible
In-Reply-To: <20220519102709.24125-16-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/22 12:27, Suravee Suthikulpanit wrote:
> +			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0]) contains zero
> +			 * or more than 1 bits, we cannot match just one vcpu to kick for
> +			 * fast path.
> +			 */
> +			if (!first || (first != last))
> +				return -EINVAL;
> +
> +			apic = first - 1;
> +			if ((apic < 0) || (apic > 15) || (cluster >= 0xfffff))
> +				return -EINVAL;

Neither of these is possible: first == 0 has been cheked above, and
ffs(icrh & 0xffff) cannot exceed 15.  Likewise, cluster is actually
limited to 16 bits, not 20.

Plus, C is not Pascal so no parentheses. :)

Putting everything together, it can be simplified to this:

+                       int cluster = (icrh & 0xffff0000) >> 16;
+                       int apic = ffs(icrh & 0xffff) - 1;
+
+                       /*
+                        * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
+                        * contains anything but a single bit, we cannot use the
+                        * fast path, because it is limited to a single vCPU.
+                        */
+                       if (apic < 0 || icrh != (1 << apic))
+                               return -EINVAL;
+
+                       l1_physical_id = (cluster << 4) + apic;


> +			apic_id = (cluster << 4) + apic;

