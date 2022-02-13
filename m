Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5534B38D4
	for <lists+kvm@lfdr.de>; Sun, 13 Feb 2022 02:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232818AbiBMBqE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 12 Feb 2022 20:46:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbiBMBqE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 12 Feb 2022 20:46:04 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00F960063
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 17:45:59 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id q7so21184071wrc.13
        for <kvm@vger.kernel.org>; Sat, 12 Feb 2022 17:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KRRMZxEYtz1HlXinA5ENlqvQgTxW7hYuZTz9HW8UPNA=;
        b=MCCkduKzjWOya/hfhRRyFIn32QwjwukArb78xUToRWLjCbJSCRGkV6lQLQ0CTW580M
         hkx70PuaCZ0WnIwJ6Prc0dpCV6CGO/7dLt1Cl+ZvJxpoa1YU3khckCchQJpu66NwLdEY
         ubuFky5G0yTwF44WJApg8RWa2EmhdHAa3yj4AhPthk8MvPrrMwcl1ims+sAxQI6S8LTW
         g0/NM+6C34enMVl0SVHXR6BgFcGrtbcs45bpsetC23AnG1Cbhc4lDHRhOLdCbsq7eAQf
         nAfZWX346WgIFUHckNRW0AVUJpzmpAy6OUhPx9+ObJdkOuIglLo9+GqfsQwlFvmd7qx5
         YbVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KRRMZxEYtz1HlXinA5ENlqvQgTxW7hYuZTz9HW8UPNA=;
        b=2E4p+sAVja89XGi6TwsM75G+iMPCvwkkCwrxNgYZxV0Ox8BGsVExFrTtZ9SVhwSuQ1
         R5zUneXXGYSlOWun0M5rlYWguCUE5fzNfjSa+PGV5rN5+EtNxtV+hRsOw0l/YrpsBybZ
         cWjA4oQQEK8MkTMU6Y+zyPNaOXzZRCp+DDrSHSZkdMyHAaHWL6CEXiTirfipyDk/Kzr6
         jC2DJTwh6lVOO50WaSR8zMTwRokpr0xBPH+I/NzcLu/m83CJPb0VuKApp6uf1ZP20P5g
         bkVnC5psBQmqGVMSRelVLaCeRha5SuNN0Z338N7+MOsqgjMqdq+6hq9Np+erDn1dLVtj
         iKLQ==
X-Gm-Message-State: AOAM533aXqj+Vmc6g4PCTo4n4SlOijzZLnGQMK3dweqdTZJ5vxe2GUnq
        Y5O6fqCnTfmFVl8+Ayscon7CEgs2uCXeA3e1NcIo/Q==
X-Google-Smtp-Source: ABdhPJw/DM54Iw8oCzdKQBt1Sgd3wnTiQGsVLmHKlZ40VA+bBpuL77SuHDVfMxUUa6CKPMGDid7PZD1Ui4H2wRP8lMk=
X-Received: by 2002:a5d:564a:: with SMTP id j10mr6068123wrw.473.1644716758462;
 Sat, 12 Feb 2022 17:45:58 -0800 (PST)
MIME-Version: 1.0
References: <20220203014813.2130559-1-jmattson@google.com> <20220203014813.2130559-2-jmattson@google.com>
In-Reply-To: <20220203014813.2130559-2-jmattson@google.com>
From:   David Dunn <daviddunn@google.com>
Date:   Sat, 12 Feb 2022 17:45:47 -0800
Message-ID: <CABOYuvb-cQZZE=QCQqRuM1GPhKwD2yLUHzzO+GFsmOGdwe5aJA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: x86/pmu: Use AMD64_RAW_EVENT_MASK for PERF_TYPE_RAW
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reviewed-by: David Dunn <daviddunn@google.com>

On Wed, Feb 2, 2022 at 5:52 PM Jim Mattson <jmattson@google.com> wrote:
>
> AMD's event select is 3 nybbles, with the high nybble in bits 35:32 of
> a PerfEvtSeln MSR. Don't mask off the high nybble when configuring a
> RAW perf event.
