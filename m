Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480AC69D16F
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 17:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbjBTQkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 11:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjBTQkM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 11:40:12 -0500
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B188B1CAD5;
        Mon, 20 Feb 2023 08:40:09 -0800 (PST)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 016821239736;
        Mon, 20 Feb 2023 17:40:06 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1676911207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qInaD/eaN8WTbVwS6QyVZ8Zw96m6hAlVUDnXEnn9AbM=;
        b=nBkxoUeYm//jpnKItttUghQPz4kVXwKtMvoQCgaIUhrwQpQYBJZFldyZILAhJA7EcYOEuD
        7HzkXsiiXJchdTsHzMqu7agtYzESX035wOzpGps1nSOeGDhI3VPIF8NPLDvnnn59BYVfqq
        0n5CvxjSFiEY6474RMniqXg4d6wnLls=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     tglx@linutronix.de, kim.phillips@amd.com,
        Usama Arif <usama.arif@bytedance.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
Date:   Mon, 20 Feb 2023 17:40:05 +0100
Message-ID: <2668869.mvXUDI8C0e@natalenko.name>
In-Reply-To: <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
 <2668799.mvXUDI8C0e@natalenko.name>
 <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello.

Thank you for your reply.

On pond=C4=9Bl=C3=AD 20. =C3=BAnora 2023 17:20:13 CET David Woodhouse wrote:
> On Mon, 2023-02-20 at 17:08 +0100, Oleksandr Natalenko wrote:
> >=20
> > I've applied this to the v6.2 kernel, and suspend/resume broke on my
> > Ryzen 5950X desktop. The machine suspends just fine, but on resume
> > the screen stays blank, and there's no visible disk I/O.
> >=20
> > Reverting the series brings suspend/resume back to working state.
>=20
> Hm, thanks. What if you add 'no_parallel_bringup' on the command line?

If the `no_parallel_bringup` param is added, the suspend/resume works.

> Is that using X2APIC?

Probably?

```
$ dmesg | grep -i x2apic
[    0.632740] x2apic: IRQ remapping doesn't support X2APIC mode
```

> If so, what about 'nox2apic' on the command line?

If `no_parallel_bringup` is removed and `nox2apic` is added, then the `x2ap=
ic: =E2=80=A6` stuff disappears from dmesg, but suspend/resume remains brok=
en.

=2D-=20
Oleksandr Natalenko (post-factum)


