Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD41539EF0
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 10:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350489AbiFAIDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 04:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350006AbiFAIDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 04:03:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2392545AD5
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 01:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654070590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Xgdti+VwJR3VZPhJkWljxyzD9ChCNJZ2LKlv/SAahT4=;
        b=Lzp63RcJB7AoHProNPwvNLJWzBO74jRLI6WAGPYqIAKRxqOccR0z74pjG+NXfrZhekIbtS
        xmijPBpLkxb8lUHNIGR03R44BJVr4EBjuy0x+VjS5LFMz1Nb/SPmPYTFT8vp5rsQF5EXkV
        ZNDkTO69loqX7z5VMhJW5g6hUk2f04Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-32-aKxRQNR8MCOdvzRMeYr2AA-1; Wed, 01 Jun 2022 04:03:09 -0400
X-MC-Unique: aKxRQNR8MCOdvzRMeYr2AA-1
Received: by mail-ed1-f71.google.com with SMTP id y13-20020a056402358d00b0042dfb820070so446350edc.6
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 01:03:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Xgdti+VwJR3VZPhJkWljxyzD9ChCNJZ2LKlv/SAahT4=;
        b=3cuWmGAFOfxa/BIGAb2kci2mO2wKWrXLepOpminFc53V+TEQ0tkHTF61Hp7BTx5KXy
         aKoLoDy0GLHuadklp7hxx9Wh4/PRu5MmuCWvjEyHpx4bfDQeCqwKxDkrtDGSkolBwUwu
         LtoKrT2e4D66yU6bJMvS9OdyNJJ1lxkg1KBIxPzaACw5FhoDax561ImJ7325rBSWW8vr
         uAurlotcLiJ0b8ZRUXTg938Y+iI3EVKzSjRw7pGqwpYYUViEoz25hccCaMCoHitDs66P
         /AuCJrpZdDUE5PQ8PiJGs3qAknYKGhzZ8c3ljIOGDWUrn9IsqSpbnoCgc1BqLSbq1nw7
         H47g==
X-Gm-Message-State: AOAM532VXwgaWFJLJCpis4RGSFPYw1nLzj/rBndc10T0vepqltQhiQ7E
        P/Dw/nB4Y2E5rLSvvqvMOQVrBjXa0jwSorxvVXBW2l+nh3ghvFQee1q9e9pxhQ1EL5+751X96Zn
        NDoPK4w5XOYYI
X-Received: by 2002:a05:6402:34c1:b0:42b:4047:20b8 with SMTP id w1-20020a05640234c100b0042b404720b8mr57064182edc.88.1654070588084;
        Wed, 01 Jun 2022 01:03:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgO9mu44S3VLlU3/wD7qn0U/ff1HsZNyCf5jYGov3NDArM7pwpMiurcfJY5MoE5bqD3r/3EA==
X-Received: by 2002:a05:6402:34c1:b0:42b:4047:20b8 with SMTP id w1-20020a05640234c100b0042b404720b8mr57064153edc.88.1654070587868;
        Wed, 01 Jun 2022 01:03:07 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id wj17-20020a170907051100b006fed9a0eb17sm388609ejb.187.2022.06.01.01.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 01:03:07 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        "Durrant, Paul" <pdurrant@amazon.co.uk>
Cc:     "Allister, Jack" <jalliste@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "diapop@amazon.co.uk" <diapop@amazon.co.uk>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "metikaya@amazon.co.uk" <metikaya@amazon.co.uk>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: ...\n
In-Reply-To: <YpcMw2TgNWzrcoRm@worktop.programming.kicks-ass.net>
References: <YpYaYK7a28DFT5Ne@hirez.programming.kicks-ass.net>
 <20220531140236.1435-1-jalliste@amazon.com>
 <YpYpxzt4rmG+LFy9@hirez.programming.kicks-ass.net>
 <059ab3327ac440479ecfdf49fa054347@EX13D32EUC003.ant.amazon.com>
 <YpcMw2TgNWzrcoRm@worktop.programming.kicks-ass.net>
Date:   Wed, 01 Jun 2022 10:03:06 +0200
Message-ID: <87r148olol.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Zijlstra <peterz@infradead.org> writes:

> On Tue, May 31, 2022 at 02:52:04PM +0000, Durrant, Paul wrote:

...

>> 
>> I'll bite... What's ludicrous about wanting to run a guest at a lower
>> CPU freq to minimize observable change in whatever workload it is
>> running?
>
> *why* would you want to do that? Everybody wants their stuff done
> faster.
>

FWIW, I can see a valid use-case: imagine you're running some software
which calibrates itself in the beginning to run at some desired real
time speed but then the VM running it has to be migrated to a host with
faster (newer) CPUs. I don't have a real world examples out of top of my
head but I remember some old DOS era games were impossible to play on
newer CPUs because everything was happenning too fast. Maybe that's the
case :-)

-- 
Vitaly

