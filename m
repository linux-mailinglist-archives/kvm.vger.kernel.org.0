Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032DF7B6BD2
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 16:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240155AbjJCOhQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 10:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240144AbjJCOhN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 10:37:13 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028CAAF
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 07:37:05 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-537f07dfe8eso11391a12.1
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 07:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696343823; x=1696948623; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3H71Ddp0doyGgICoMWyxNf2GnEn07JdKBfrTYW/a2tY=;
        b=DHY/802L91Y3bsbXfEh4FN5smepxNvCcp0/hs4yiqKQB6i88Oo2ZeXqrQZDX3BlwfE
         51tqquR1UvGRAiR3n6X/s2ZSxok+tB8MokJIqda8j8ARfuYJ15XAqL4wFuaS0ivAyHRk
         qOZ/OiSEGINuKHTFYUdqOSWWufiyOcWQTFcVCIeESWc0kPHDIwk35IV/tR5YokRSci2y
         5xLuOwiRuYGfIOOnf3XUNdEEIKaxYwMr3Nyqgxyw9swii7lPxWV0FcAyDO1zso5YnMts
         hacaY6IkFSkOd/GNdAgj7Zfvve4BD1IdYptjoz3DCjQxZ/l314z6Sau0FVIMjm/Y0szA
         UVvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696343823; x=1696948623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3H71Ddp0doyGgICoMWyxNf2GnEn07JdKBfrTYW/a2tY=;
        b=LS6NxkRsGlJzRrAajMxjLaXE/eS4UpDiTQYRSuPOXFpaMNsuY0H1suHuL6N7qLem1k
         8ShmX6vQ5eYF1LF1iC8wgRLkqBsgLu4NYziFTxfi72UG5CqJGBM548lL5H2ouTzqd3Lq
         Vm1ASSmY78gvcqUmZkfredY01XI3yF9XkTrlV5vf52T0rRsXBFrayoySLlpAKThsu1It
         RA60214xQ8jNDw7SUrhzypMcC11TmCBqyM6fBn6Op+OmgxiFZnLrJbJzSexhQZYT69+4
         pRdzX5iRPPMFHCiqBmg/QLPRBvibggAhzF21HlPCyTG1u1Q7uqukRK0ZXTVP+fpetSrp
         RmQQ==
X-Gm-Message-State: AOJu0YxnXxjM6xkMYx3vbfAG5hM7jIbLus84m3qRLjQV5990FVjslsrN
        KsZ00BrgLAh0EGq5NV63N8LF9S3YiJPwyQ3zAmqc0A==
X-Google-Smtp-Source: AGHT+IHXc3WAfKlNdinaDDcPUvQoOeQzdqAXe81rxIcxpa0Ed7oQHIWBrnmmMckOGzulalTSLX6S1L1E64CkioL5uRo=
X-Received: by 2002:a50:d09e:0:b0:52f:2f32:e76c with SMTP id
 v30-20020a50d09e000000b0052f2f32e76cmr137455edd.2.1696343823200; Tue, 03 Oct
 2023 07:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <ZRwcpki67uhpAUKi@gmail.com>
In-Reply-To: <ZRwcpki67uhpAUKi@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 3 Oct 2023 07:36:48 -0700
Message-ID: <CALMp9eSozxk-nuwWF3Xvg7fqC5doHKc5-6Nh40EnmzVRX+EQ4Q@mail.gmail.com>
Subject: Re: kvm/x86: perf: Softlockup issue
To:     Breno Leitao <leitao@debian.org>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org, rcu@vger.kernel.org, rbc@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 3, 2023 at 6:52=E2=80=AFAM Breno Leitao <leitao@debian.org> wro=
te:
>
> I've been pursuing a bug in a virtual machine (KVM) that I would like to =
share
> in here. The VM gets stuck when running perf in a VM and getting soft loc=
kups.
>
> The bug happens upstream (Linux 6.6-rc4 - 8a749fd1a8720d461). The same ke=
rnel
> is being used in the host and in the guest.

Have you tried https://lore.kernel.org/kvm/169567819674.170423.438485398062=
9356216.b4-ty@google.com/?
