Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21526677B53
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 13:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbjAWMon (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 07:44:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjAWMom (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 07:44:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A6410F2
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 04:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674477834;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IxYrNbwYUeSdisNJbyzmWdAS660Zl/QVXKAFCiimd20=;
        b=h0VTO4g9XPYnX0OJOoZ/exjRzMZdxNLvKtgxWUP8vWx5fiQCZaZx+TLbjfeUNGJ5y6DAeC
        dMLgIop//SZzMq+DGKjNZHwHKZU1Ikby/x0kTYh0+Kkr6cxKDECw9wyrETM7KM3GnL4QuW
        KXKnn0HMTjC1ffyRrvT4EoV6dw12x9s=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-67-jaZB8yg-Ooe-ilI-1td7yg-1; Mon, 23 Jan 2023 07:43:53 -0500
X-MC-Unique: jaZB8yg-Ooe-ilI-1td7yg-1
Received: by mail-wr1-f71.google.com with SMTP id m12-20020adfa3cc000000b002b881cb0cb4so1943335wrb.3
        for <kvm@vger.kernel.org>; Mon, 23 Jan 2023 04:43:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IxYrNbwYUeSdisNJbyzmWdAS660Zl/QVXKAFCiimd20=;
        b=yF19H1pLCyJ3r8l8546gxJOIGddzvU6pB0Bm2is0sv1ERKFthmlH1pm4sCeFXi6pRd
         bitOO7Ru1ndKxnVxo+URF0LuFTh0eOvhR8JqiVrd/eESdY4bXsQFjBCkqtMXpqUhYTLG
         +Gma8gaS+7kNFVkKf9i1SqQ3yMGkWKqwxtKqFiojNr3MJOpb9iaMdEr8YNLlTsbOq+Hz
         /8qri09J7DWdS4JqMLzcedOuVZQ7g/wKGuWxy00WsP89swXp4LXWvNzLCZtjoTPvR8tG
         5KmizYQvWJiNgIr8S1BLJ350TiM4z+J9wFJCGqqHc79/Xcmcp3nh70zj7ldsyP1D1+xo
         RtrA==
X-Gm-Message-State: AFqh2ko6wGSwGY6GwjkwrfuYwfqE3rut2rUx2BTryHmeArblojs9ZrsQ
        zfY1NOkqb8Qe7pmG6I8shstE9zKsdX0tA4jtlf5i/jKPSUgf/JdZ6nB5Xhi87K904MFPmouVVrB
        4p6IhxnOWDb/w
X-Received: by 2002:adf:e30c:0:b0:2be:1fae:690e with SMTP id b12-20020adfe30c000000b002be1fae690emr20464602wrj.50.1674477832152;
        Mon, 23 Jan 2023 04:43:52 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuix53NTHu33GjEUZ171NiQQ++gObacGvk30yTVWI6tklXTd0eKfLleBj0mVvX3+0rkglkjhQ==
X-Received: by 2002:adf:e30c:0:b0:2be:1fae:690e with SMTP id b12-20020adfe30c000000b002be1fae690emr20464595wrj.50.1674477831955;
        Mon, 23 Jan 2023 04:43:51 -0800 (PST)
Received: from localhost ([2a01:e0a:a9a:c460:ada2:6df5:d1b0:21e])
        by smtp.gmail.com with ESMTPSA id h10-20020a05600016ca00b00267bcb1bbe5sm4873735wrf.56.2023.01.23.04.43.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 04:43:51 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 23 Jan 2023 13:43:51 +0100
Message-Id: <CPZKUO224B8I.3UNLB18V94IF2@fedora>
To:     "Paolo Bonzini" <pbonzini@redhat.com>
Cc:     <kvm@vger.kernel.org>, <rjarry@redhat.com>,
        "Christophe Fontaine" <cfontain@redhat.com>, <xiaoyao.li@intel.com>
Subject: Re: [RFC] KVM: x86: Give host userspace control for
 MSR_RAPL_POWER_UNIT and MSR_PKG_POWER_STATUS
From:   "Anthony Harivel" <aharivel@redhat.com>
X-Mailer: aerc 0.13.0-123-g2937830491b5
References: <20230118142123.461247-1-aharivel@redhat.com>
 <CABgObfZdvd-=cqQ1aLVsJNuBd830=GJW+PMj1iaq7yMa2Za_7w@mail.gmail.com>
 <CPX65W5M0LSW.17ZS900QMBZLL@fedora>
 <CABgObfb4uYa817tG9Q8vS-O0XVqom1CRia+g=hSuAYWOB2+xHQ@mail.gmail.com>
In-Reply-To: <CABgObfb4uYa817tG9Q8vS-O0XVqom1CRia+g=hSuAYWOB2+xHQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri Jan 20, 2023 at 5:57 PM CET, Paolo Bonzini wrote:
> On Fri, Jan 20, 2023 at 5:48 PM Anthony Harivel <aharivel@redhat.com> wro=
te:
> > So I'm wondering if the contexts switching (KVM->userpace->KVM) to
> > update all MSRs will cause performance issues?
>
> How often do you anticipate them to be read by the guest?
>

The more often we can update the register, the more accurate we can be.
Not accurate in terms of consumption but in terms of time. Imagine
a burst of data that needs to be processed by a vCPU every 100ms, if we
update the registers every seconds we will never target which burst is
consuming the most. It's a total made up example but it gives an idea.
But we have to keep in mind that those energy counters are updated at
the average rate of ~1ms.


> > What I'm pretty sure is that updating the values should be done
> > separately from the callback that consume the value. This would ensure
> > the consistency of the values.
> >
> > In the hypothesis those MSRs are handled within KVM, we can read MSRs
> > with rdmsrl_safe() but how can we get the percentage of CPU used by Qem=
u
> > to get a proportional value of the counter?
>
> If you are okay with only counting the time spent in the guest, i.e.
> not in QEMU, you can snapshot the energy value when the vCPU starts
> (kvm_arch_vcpu_load, kvm_sched_in) and update it when the vCPU stops
> (kvm_sched_out, kvm_get_msr and post_kvm_run_save).
>
> Paolo

I think this is great idea and would have worked perfectly if we were
able to get the individual core power consumption. However we are down
to, in the best case, to the power consumption of all Cores per package
(PP0/Core power plane). And in the server CPU Family (i.e Xeon), we only
have the Package power plane which include consumption of all cores in
the package plus the uncore power consumption (i.e. last level of caches
and memory controller; consumption of DRAM memory not included). So
depending on the workload of all the cores and the uses of the uncore
part, the energy counter of the package is increasing more or less
quicker between samples of the same period.

Anthony

