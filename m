Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF6A699672
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 14:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBPN5g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 08:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjBPN5d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 08:57:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F7C3B21B
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 05:56:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676555807;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yAY9A4DgDYTs34l5F4SNL1vgPiLPs32KphqeD6tWbMs=;
        b=MMbSjKz8quNSwiwF5dIk7yZRucOpvGi3o/+m7kt22fZBv0HskAj0m2e0H3WNENrSYkrRED
        lEUaRiDnC8yuqohTh1gmFat/XArOJ0lDSphk0Kp20iIQmq32Vx10G+FHZk2VpeghGSJaM/
        B9dKJu5DNlVbO4E0X1v50Thj+G8khc0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-187-T-sz2bDEPnOQnDTM60nalA-1; Thu, 16 Feb 2023 08:56:46 -0500
X-MC-Unique: T-sz2bDEPnOQnDTM60nalA-1
Received: by mail-wm1-f70.google.com with SMTP id j20-20020a05600c1c1400b003dc5dd44c0cso855530wms.8
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 05:56:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:reply-to
         :user-agent:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yAY9A4DgDYTs34l5F4SNL1vgPiLPs32KphqeD6tWbMs=;
        b=XMZkr7MK9iITN8jIYj354H7+L+ha7cX9p7linT8iQA400KQZLje4qntmiV1pwzmhJE
         NkIDPg7cUtfzvIXSSB9bO5NSlZt/ZEExyWq/fQ6yBYxjLpwl9UGY4EW04LX8qamPajW9
         hWmzs8uyTE6zlLzStB9u3fNlZ3XHkd1SBqBJ/bFfmunidyYdDJO2U038A00r9ICmlOh0
         Tu7d8tEkQG/twnrDiu7udEg7QobcLCnF/zUHhGMVwfc0nwW02Ib1OPBTPpfELjJFFWD5
         Nsi9LJmn/sy9YAR+qMBhm76MAXe8sVqYh9Rd+scCYKtLnDSv7aWnCqX5uq0hP5FmpTeU
         +iqw==
X-Gm-Message-State: AO0yUKUQT6JNZPJYDsmVSiJonvevmc3AoXJX1K0+UCFxCD1sXGvZN2Hm
        hs74t0sbWL+jTct6apUNBqUTFr0xnBh+OfZ9Si+5OlpIQcmWQjxQAXkJunfJA5bHdDsGrg0VMAv
        PAkg/LZ1cwXM7
X-Received: by 2002:adf:d1c1:0:b0:2c3:be89:7c2a with SMTP id b1-20020adfd1c1000000b002c3be897c2amr2008358wrd.13.1676555804825;
        Thu, 16 Feb 2023 05:56:44 -0800 (PST)
X-Google-Smtp-Source: AK7set/UHB8LhBNMXatokxc3iGpvsyF0+wMJFk3Dy2w1kDt1q6H6J++YHovfDvwaPmRyJa35CX0Pug==
X-Received: by 2002:adf:d1c1:0:b0:2c3:be89:7c2a with SMTP id b1-20020adfd1c1000000b002c3be897c2amr2008337wrd.13.1676555804517;
        Thu, 16 Feb 2023 05:56:44 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id a8-20020a5d5088000000b002c567881dbcsm1579374wrt.48.2023.02.16.05.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:56:44 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Pavel Dovgalyuk <pavel.dovgaluk@ispras.ru>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Mark Burton <mburton@qti.qualcomm.com>,
        Bill Mills <bill.mills@linaro.org>,
        Marco Liebel <mliebel@qti.qualcomm.com>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Mahmoud Mandour <ma.mandourr@gmail.com>,
        Emilio Cota <cota@braap.org>, kvm-devel <kvm@vger.kernel.org>,
        "Wei W. Wang" <wei.w.wang@intel.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: Future of icount discussion for next KVM call?
In-Reply-To: <CAHDbmO3QSbpKLWKt9uj+2Yo_fT-dC-E4M1Nb=iWHqMSBw35-3w@mail.gmail.com>
        ("Alex =?utf-8?Q?Benn=C3=A9e=22's?= message of "Thu, 16 Feb 2023 10:23:58
 +0000")
References: <87bklt9alc.fsf@linaro.org>
        <CAHDbmO3QSbpKLWKt9uj+2Yo_fT-dC-E4M1Nb=iWHqMSBw35-3w@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Thu, 16 Feb 2023 14:56:43 +0100
Message-ID: <875yc1k92c.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex Benn=C3=A9e <alex.bennee@linaro.org> wrote:
> (replying all because qemu-devel rejected my email again)

Just to see what we are having now:

- single qemu binary moved to next slot (moved to next week?)
  Phillipe proposal
- TDX migration: we have the slides, but no code
  So I guess we can move it to the following slot, when we have a chance
  to look at the code, Wei?
- Markus asked to have only one topic per call
  (and it is reasonable)
- the future of icount cames with documentation to read before the call.

So I think we can do the icount call this week, and discuss here on list
if we move to a weekly call on the same slot.

What do you think?

Later, Juan.

