Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E116569EE
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 12:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiL0L21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 06:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiL0L14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 06:27:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD788656D
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672140421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tYCATXIRInao3igNKiE7HLwP0l5ypFCWPTUkIt/6IA0=;
        b=hYVaPFRVAic6vTD5jbRpWomLmK+xAOxKilJV3KE1DrKk2WpL/X0XBXzS21+fx3QyS/3nrL
        s+o9bwvqEgA9Bh5eY84bNH7YA85Y1Ofc0Q2qLRWcVjlKKcbv7uSHXK836FOne08Lf9t34v
        cNEANkqEbdyAUHS2RqhKFcEnW5Ke6ZU=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-2-Hz4IAHxwMAyLgnRvAoetGA-1; Tue, 27 Dec 2022 06:25:57 -0500
X-MC-Unique: Hz4IAHxwMAyLgnRvAoetGA-1
Received: by mail-ed1-f69.google.com with SMTP id i8-20020a05640242c800b004852914ce42so2982894edc.6
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:25:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tYCATXIRInao3igNKiE7HLwP0l5ypFCWPTUkIt/6IA0=;
        b=bJ5mZoifMDnrfDhfZrAsjTpHTa53e2zDeGnA6m4AM/+s0DjOBMRtjpcj5S7VcWfLZw
         3tcqQQeYAnXpJsfm/ixXxHpNAteBHCwMifEm/3zTfkgwHGj4f+iZT1jH23elx9P+7UqH
         lYNtycEjIOPAPacZgi0JZjeYmsPSaNYthW3EwDfCl2lqoGGO1WAwQacFJhCKvTZTSv6X
         wERjxKg1Q+leAyx1vrGbrbP6W4r1owAvWp43swVIH720l0un6D52k+NKm442BnmwX89P
         FBFsAhSnk6HN1jF6oSm+7xTR5Ey2+D/C313UaOPII6VRAjq+yt6LP36DFb001d3bai/T
         8BfA==
X-Gm-Message-State: AFqh2krCd4vApvKtK4CfaFi+LpWRO6ZkN2i3ngdlwN6m3nVCsRyUzJJG
        aAUAZeTJxDzJ/kZO1ScuAEFO4TasoLjugDgrOMAN92fJCag8at7fqA3OwBzZCN7Lu5EoQnoad2s
        cb5zQ0JxQ1ZwV
X-Received: by 2002:a17:906:7188:b0:7c0:f117:6990 with SMTP id h8-20020a170906718800b007c0f1176990mr18263829ejk.41.1672140356092;
        Tue, 27 Dec 2022 03:25:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuTP7i93tBCwXyLQpLIXG+XCM2m94bERKbwavktfnegZNG48TOZveL25h7nVRU130zhxlAa4Q==
X-Received: by 2002:a17:906:7188:b0:7c0:f117:6990 with SMTP id h8-20020a170906718800b007c0f1176990mr18263820ejk.41.1672140355863;
        Tue, 27 Dec 2022 03:25:55 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id y26-20020a1709063a9a00b0078c213ad441sm5883575ejd.101.2022.12.27.03.25.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Dec 2022 03:25:55 -0800 (PST)
Message-ID: <f37873fe-0340-e50c-a168-1b9ee12de890@redhat.com>
Date:   Tue, 27 Dec 2022 12:25:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v4 11/32] KVM: x86: Inhibit APIC memslot if x2APIC and
 AVIC are enabled
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
References: <20221001005915.2041642-1-seanjc@google.com>
 <20221001005915.2041642-12-seanjc@google.com>
 <90d4a2a1733cdb21e7c00843ddafee78ce52bbdc.camel@redhat.com>
 <Y5zBH+2VuPJi4yYV@google.com> <Y5zJraa0ddooauXB@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Y5zJraa0ddooauXB@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/16/22 20:40, Sean Christopherson wrote:
> I was hoping to have a name that communicate_why_  the memslot needs to be
> inhibited, but it's turning out to be really hard to come up with a name that's
> descriptive without being ridiculously verbose.  The best I've come up with is:
> 
> 	allow_apicv_in_x2apic_without_x2apic_virtualization
> 
> It's heinous, but I'm inclined to go with it unless someone has a better idea.

Can any of you provide a patch to squash on top of this one (or on top 
of kvm/queue, as you prefer)?

Paolo

