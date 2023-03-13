Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0943E6B80ED
	for <lists+kvm@lfdr.de>; Mon, 13 Mar 2023 19:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbjCMSmM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Mar 2023 14:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjCMSmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Mar 2023 14:42:06 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F0BBB95
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 11:41:38 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id p9-20020a17090a930900b00237a7f862dfso7528740pjo.2
        for <kvm@vger.kernel.org>; Mon, 13 Mar 2023 11:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678732852;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i1cMhUCsMAEY3RhauMvZhOm9VNjiipIgBj4auF8E5TU=;
        b=IWBCqhziCNdR1dsF/maJARObwkoJ7wRs0/ztQQU4L/6oZ7ngAaS8SXta7kJxLq0CCL
         S/jyn/wAC7O0RZmrbDiknjQ0p8cnsa2rEPoM0gASnYlX8m5eQ0WxXde8jIdXkpEAGh+N
         0KSyHNh6q4jNlmUuFPYS4ZPSLCnXs9mANVq15fYc8fYcnRCaInSN4hOph5yAdbMkIM18
         PXm+V1yfBpcT7AJhytN6Q2kE5vTGLnuspLNxlr8kpxKSzl3BhxUu68GJjiDR9r6HJn0M
         grSlm8q7Bu0QN24EETFiP1S6VyyxT4KlJH8x9FLuFTC413mXiijRP2xnpg2n3OghDDUh
         Hb8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678732852;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i1cMhUCsMAEY3RhauMvZhOm9VNjiipIgBj4auF8E5TU=;
        b=LPnz0+p8dW1MrbPIykjc7ur5MaOmg+RgEVUFT20D64lQgHNLeF+PVJx28Gn7I8agfT
         U3G4ADlsST7shZV/mbxUX/0LZoS6q+j8R0hCA6UTOgcSI3UKn38f3gmA76NTh05dVZ9a
         HQyxgCDUr5txH0X05qlnedUSEn8eMt/U1h0dTxDfdME03aZaq2rQ0vrAqmzaVLgt1ibI
         i2YaVscDopJCVmWcMB8phIfsF3GFMP8GwVkq68phJTcsPDeL4bfONN41JMH/IqSnxd32
         QdXubtoIhAERCadYCg8yNAVEXUzP9DAkp5wYRSsUDZQwPc0QqZk1R7XWBwN6zPuSXacB
         xH4Q==
X-Gm-Message-State: AO0yUKVJcRc4U+I6U7/NFXfIN1rA9RTWOcNzr9B0jcZKKiISRNOf/8S4
        XJ/anhGqFmast6YEKhlOAG1zc+c49fA=
X-Google-Smtp-Source: AK7set9e5dsb0NIvYqN7F2B3dpwL3KOMDW+bYzu1Aw+sN447o+52JAjY9p/TgOkrd36VARKget5RemBsP6E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:dc83:b0:23b:462b:ffc0 with SMTP id
 j3-20020a17090adc8300b0023b462bffc0mr2402010pjv.0.1678732852033; Mon, 13 Mar
 2023 11:40:52 -0700 (PDT)
Date:   Mon, 13 Mar 2023 11:40:50 -0700
In-Reply-To: <4ab086ad30cf5e1ddea863e1a2bcfa21ca72d37e.camel@intel.com>
Mime-Version: 1.0
References: <20230310214232.806108-1-seanjc@google.com> <20230310214232.806108-8-seanjc@google.com>
 <4ab086ad30cf5e1ddea863e1a2bcfa21ca72d37e.camel@intel.com>
Message-ID: <ZA9t04+rtW22AMQq@google.com>
Subject: Re: [PATCH v2 07/18] x86/reboot: Disable virtualization during reboot
 iff callback is registered
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chao Gao <chao.gao@intel.com>,
        "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023, Huang, Kai wrote:
> On Fri, 2023-03-10 at 13:42 -0800, Sean Christopherson wrote:
> > Attempt to disable virtualization during an emergency reboot if and onl=
y
> > if there is a registered virt callback, i.e. iff a hypervisor (KVM) is
> > active.  If there's no active hypervisor, then the CPU can't be operati=
ng
> > with VMX or SVM enabled (barring an egregious bug).
>=20
> IIUC, this patch is the final one that you want to achieve how the "disab=
le
> virtualization" callback should work in the non-KVM core kernel (the rest
> patches are related to moving VMXOFF code to KVM as the core-kernel now j=
ust
> calls the callback, etc). =EF=BF=BD
>=20
> There are middle step patches (2-7) to eventually help to get to this poi=
nt.=20
> But to be honest, personally, I am not sure whether those patches are nec=
essary,
> i.e. to me they actually cost more time to review since I have to think w=
hether
> such intermediate status is reasonable or not.  I am wondering whether we=
 can
> just merge those patches together as single one, so it's easy to see what=
 is the
> final goal to achieve?

I agree that the fine granularity makes it difficult to see the final form,=
 but
from a bisection perspective I really, really want each change to be isolat=
ed as
much as possible.  This code is extremely difficult, if not practically imp=
ossible,
to exhaustively test due to multiple points of entry from "this should neve=
r happen!"
types of flows.  If any of these changes breaks someones deployment, I want=
 to
make it as easy as possible for that someone to determine exactly what brok=
e.
