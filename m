Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23DFE58D90D
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 14:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243371AbiHIM72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 08:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243366AbiHIM7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 08:59:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72A151836B
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 05:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660049961;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KBecFOB/Bo1T/mXz5cBJlBh2olRYpsGjGSOjfij+x2Q=;
        b=DpCOrrwtPCt0KsQ1BLPqhSNTglWQd0LHqcPYA1E+aoZ5WsXdbD1SrNcGm5hG5CeKY8fOs6
        8h9I36etjieS0OVaR06bqhV6sxKI4sa1NelfeUE8usdq6BlDkd0/7ovY5gCOswbf3yOEIg
        4+Xl154nSIp4StQO7exUJ7ZGmYTS3Zk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-oiNNVGpAMqKgY1-uXcDq3w-1; Tue, 09 Aug 2022 08:59:15 -0400
X-MC-Unique: oiNNVGpAMqKgY1-uXcDq3w-1
Received: by mail-ed1-f70.google.com with SMTP id c14-20020a05640227ce00b0043e5df12e2cso7238282ede.15
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 05:59:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=KBecFOB/Bo1T/mXz5cBJlBh2olRYpsGjGSOjfij+x2Q=;
        b=UWfSolQBuQPgDBhvE121VPkxThawskKYJn8/hmc1egV6MNkqThv3tXMIp5zRO+kQCJ
         A/eJDy2Nkbkw2Rs8ETr3RzKH+l9VTtGO3M8irYT0qyaGs+TbCB62Qc2gUuKSWHiRYVOl
         /244SfGj7QFgnLOav+u1fi/16rMmxWPS8BCMpzuKM14H94qj3AQtO1Ihcl7aZzprWmAK
         1IwD7b4KDVmfxgk2u8136c8PBpdWP+ZcjJjW8WmTLclHNKAwnGoPODxpWaO7v11K2Lib
         kojAXja5Z4KekRkFOYgOMlREJzpjpjRm1pciD2IPok2v/d2rWkDn5PliW04M6ZWImH6h
         VB6A==
X-Gm-Message-State: ACgBeo2Y3DENBrfInpJ69YTnRUZFrFPS23vCP11vK7tsRgqzhQzsu0LO
        iFsl/Z9rqlCDrUGYMx2Rz7jHNTn9itiPcj28Yqw1xtzs8dvulPZDmrTROcpn8Hr+2r7glUok3lE
        qfUAHsSUF5oSJ
X-Received: by 2002:a05:6402:1907:b0:43d:e91d:e544 with SMTP id e7-20020a056402190700b0043de91de544mr22039356edz.107.1660049954828;
        Tue, 09 Aug 2022 05:59:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4wUw7Vpw3aM/6l7uafzRR30NIAU8ZjnuvsDJ5chqhOQYeDofcjkztMJTSa6IdTzmsVZH8dFg==
X-Received: by 2002:a05:6402:1907:b0:43d:e91d:e544 with SMTP id e7-20020a056402190700b0043de91de544mr22039348edz.107.1660049954607;
        Tue, 09 Aug 2022 05:59:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id b2-20020a1709063ca200b0073095b4b758sm1090273ejh.218.2022.08.09.05.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 05:59:13 -0700 (PDT)
Message-ID: <43e258cc-71ac-bde4-d1f8-9eb9519928d3@redhat.com>
Date:   Tue, 9 Aug 2022 14:59:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v3 2/2] KVM: x86/xen: Stop Xen timer before changing IRQ
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Coleman Dietsch <dietschc@csp.edu>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        skhan@linuxfoundation.org, Pavel Skripkin <paskripkin@gmail.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org,
        syzbot+e54f930ed78eb0f85281@syzkaller.appspotmail.com
References: <20220808190607.323899-2-dietschc@csp.edu>
 <20220808190607.323899-3-dietschc@csp.edu>
 <c648744c096588d30771a22efa6d65c31fffd06c.camel@infradead.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <c648744c096588d30771a22efa6d65c31fffd06c.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/9/22 11:22, David Woodhouse wrote:
> On Mon, 2022-08-08 at 14:06 -0500, Coleman Dietsch wrote:
>> Stop Xen timer (if it's running) prior to changing the IRQ vector and
>> potentially (re)starting the timer. Changing the IRQ vector while the
>> timer is still running can result in KVM injecting a garbage event, e.g.
>> vm_xen_inject_timer_irqs() could see a non-zero xen.timer_pending from
>> a previous timer but inject the new xen.timer_virq.
> 
> Hm, wasn't that already addressed in the first patch I saw, which just
> called kvm_xen_stop_timer() unconditionally before (possibly) setting
> it up again?

Which patch is that?

Paolo

