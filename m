Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA61798446
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 10:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjIHImL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 04:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjIHImI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 04:42:08 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA17E1BEA
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 01:42:04 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-400a087b0bfso19092455e9.2
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 01:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1694162523; x=1694767323; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UjxBF6jjkhMf/hFHeZyE6a+2YSUIQA0tq7o+K5UPXKA=;
        b=SaF7RF+twTzoLooa0KtmptT5phM7TQx2NqSRao/+nsJC+tCVFsqfeC8iwnyuuv8sTG
         xHcwRHFw8ykjpyVba8IbYUejUhujIGV/af9KyA5VDWMNKwOEWi96JtPSx1k2miCXe68Z
         +fKvgpXqqMKohuo2boQREHBOmJFDCahxH+lz84vA9AVXTOxXi36SVrX/vESC3IgNHveg
         +/yPmlTG2P4zkqt0g9d57IpghUtOGqExJrYQAFZGBieu50nuQ+JSlgLtEvZi6LjjtuAZ
         txU19xsD7IiXd+OVpE1l+YEzN1HOpqnojBv/oIdocPm5mMl7ZVWQP3JUe2guhdt9EzQA
         8+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694162523; x=1694767323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UjxBF6jjkhMf/hFHeZyE6a+2YSUIQA0tq7o+K5UPXKA=;
        b=mkj9cShx4IK4bJVNdsARkBzjPLep+TzSzHRyRFQe2bH4oivbEZqtj33kA5LdLtCsag
         MNcn8ix4YXyfCEA6TQ2Ohssh8E6g36mLH11V85iug+8gxAwC49IA0Okc3hIIaul+Fvze
         asnr21siIkteAlEq9cw5lHq/RuJzTjrawvq5iMJERgcWae30bTVpMzRBGi6nDPUNg9u8
         MDcC5uGTVj4FbI41OLHr5J2xEHpe+xDKR9MeIt21L7vlxpz8W/g73UncP+4+Z8yulSAf
         b/UT7VQy3R4DhQLmHWylJ0VBZBLD6NIU4xbKCnYOHUAKqbP7zYimmkTuJKsXo29vvutb
         NZgA==
X-Gm-Message-State: AOJu0YwxUKmH9TGQc/D/+cl+xQan0nzWzEXFQn37fght2htIlDFxU843
        DGlMOWV9WIOv8d/7ubplNX7O1Q==
X-Google-Smtp-Source: AGHT+IHTuLXLZHfe27K1s07haiW48sUeJVzNAV9aTtn75hkax4ayDfyRJnBrtKm1cVpQYe55sldW+w==
X-Received: by 2002:a05:600c:5120:b0:402:f517:9c07 with SMTP id o32-20020a05600c512000b00402f5179c07mr1332629wms.0.1694162523051;
        Fri, 08 Sep 2023 01:42:03 -0700 (PDT)
Received: from localhost (cst2-173-16.cust.vodafone.cz. [31.30.173.16])
        by smtp.gmail.com with ESMTPSA id o12-20020a5d408c000000b003142ea7a661sm1500224wrp.21.2023.09.08.01.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Sep 2023 01:42:02 -0700 (PDT)
Date:   Fri, 8 Sep 2023 10:42:01 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Michael Tokarev <mjt@tls.msk.ru>
Cc:     Colton Lewis <coltonlewis@google.com>, qemu-devel@nongnu.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        qemu-trivial@nongnu.org, qemu-stable <qemu-stable@nongnu.org>
Subject: Re: [PATCH] arm64: Restore trapless ptimer access
Message-ID: <20230908-c42425ed51b75d247052cfde@orel>
References: <20230831190052.129045-1-coltonlewis@google.com>
 <7d3615d0-d501-a28c-eebc-b3f7a599fc23@tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d3615d0-d501-a28c-eebc-b3f7a599fc23@tls.msk.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 07, 2023 at 10:31:20PM +0300, Michael Tokarev wrote:
> 31.08.2023 22:00, Colton Lewis wrote:
> > Due to recent KVM changes, QEMU is setting a ptimer offset resulting
> > in unintended trap and emulate access and a consequent performance
> > hit. Filter out the PTIMER_CNT register to restore trapless ptimer
> > access.
> > 
> > Quoting Andrew Jones:
> > 
> > Simply reading the CNT register and writing back the same value is
> > enough to set an offset, since the timer will have certainly moved
> > past whatever value was read by the time it's written.  QEMU
> > frequently saves and restores all registers in the get-reg-list array,
> > unless they've been explicitly filtered out (with Linux commit
> > 680232a94c12, KVM_REG_ARM_PTIMER_CNT is now in the array). So, to
> > restore trapless ptimer accesses, we need a QEMU patch to filter out
> > the register.
> > 
> > See
> > https://lore.kernel.org/kvmarm/gsntttsonus5.fsf@coltonlewis-kvm.c.googlers.com/T/#m0770023762a821db2a3f0dd0a7dc6aa54e0d0da9
> > for additional context.
> > 
> > Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> > ---
> >   target/arm/kvm64.c | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> > index 4d904a1d11..2dd46e0a99 100644
> > --- a/target/arm/kvm64.c
> > +++ b/target/arm/kvm64.c
> > @@ -672,6 +672,7 @@ typedef struct CPRegStateLevel {
> >    */
> >   static const CPRegStateLevel non_runtime_cpregs[] = {
> >       { KVM_REG_ARM_TIMER_CNT, KVM_PUT_FULL_STATE },
> > +    { KVM_REG_ARM_PTIMER_CNT, KVM_PUT_FULL_STATE },
> >   };
> >   int kvm_arm_cpreg_level(uint64_t regidx)
> 
> While this patch itself is one-liner and trivial and all, I'd rather
> not apply this to the trivial-patches tree, - it requires a little
> bit more than trivial expertise in this area.
> 
> So basically, ping for qemu-arm@ ? :)
>

I agree that qemu-trivial should not have been CC'ed for this patch.

Thanks,
drew
