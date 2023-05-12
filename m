Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4D7700191
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 09:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240178AbjELHgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 03:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240025AbjELHgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 03:36:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D1330CD
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 00:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683876931;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gJi6R2h6fr+KnyVNJLRe1xRS0/CMbNjx3YhKemzxNrw=;
        b=Mf+M2eFSKggx5kbEyFCYFKsphF0TgGob5A7lpQpzKLk2bz6rHw5226B3IOsDrpVjSSM1lp
        /ME/nHDwDdBSGl1XtV3KHcKgbbtWBeAgwWrPcEe2zeEvPJhJhbQoZ2+HTQmtfDGeO8hN+9
        8BfF5mi16zPEC7j0loO8DD+oSKQFq1c=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403--sSZsRLENpidxsZK1GgASA-1; Fri, 12 May 2023 03:35:30 -0400
X-MC-Unique: -sSZsRLENpidxsZK1GgASA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f422dc5ee5so34422905e9.0
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 00:35:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683876929; x=1686468929;
        h=content-transfer-encoding:mime-version:message-id:date:reply-to
         :user-agent:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gJi6R2h6fr+KnyVNJLRe1xRS0/CMbNjx3YhKemzxNrw=;
        b=BSGGPMYbFzKJHJENy6sN6WpdQpgKBM0T/HEXvUZmgCBLIpbrQD9N4aX39Au011qadG
         FzsTeJg9t4/VIfNXQW79C9NMlNctSw02mow6aCgDIPP91VOTMbQnQWY0KjqB8tzV1Xvb
         SQEguzIzfNUBjAE2wWdb+lj93WZ7RtagLCdg7MCYH18eqz7MLjrCZKz/cuf1bRt6XwBU
         1QuYCXrkM6WXdVLOcNADL6xcB307DDdniXGijPJmaMDU4iP8lPN4vwaDV+9uTvoJv5Lp
         lkAYpMRjDhMPsesY9H7fc0KIEzoFTPxoupa99lfxPNKnWGuke4hke7AqBAt03WJoT2Az
         J/AA==
X-Gm-Message-State: AC+VfDyF2cAcjZ2joOFPeczvrZtxiq2pN7e7faYvbFg0o88axwavNpky
        esciBFI5ZJwU4bzQK3Q9R1v5lz6b53h/dmI1dy07XRCr9amUHLsysjAEmvHOqLr6rjwEBxMoVt1
        59nGY/8qhZOPn
X-Received: by 2002:a1c:6a18:0:b0:3f4:294d:8529 with SMTP id f24-20020a1c6a18000000b003f4294d8529mr10719242wmc.19.1683876929426;
        Fri, 12 May 2023 00:35:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7wRZVuLj0kS1cyz5y8wEEXMI5SASxMVTfSl4nfYToCVeDTexo4f+uWfZhdbmPuul61yjY8og==
X-Received: by 2002:a1c:6a18:0:b0:3f4:294d:8529 with SMTP id f24-20020a1c6a18000000b003f4294d8529mr10719223wmc.19.1683876929097;
        Fri, 12 May 2023 00:35:29 -0700 (PDT)
Received: from redhat.com (static-92-120-85-188.ipcom.comunitel.net. [188.85.120.92])
        by smtp.gmail.com with ESMTPSA id s18-20020a5d4252000000b00304aba2cfcbsm22737813wrr.7.2023.05.12.00.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 00:35:28 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     afaerber@suse.de
Cc:     ale@rev.ng, anjo@rev.ng, bazulay@redhat.com, bbauman@redhat.com,
        chao.p.peng@linux.intel.com, cjia@nvidia.com, cw@f00f.org,
        david.edmondson@oracle.com, dustin.kirkland@canonical.com,
        eblake@redhat.com, edgar.iglesias@gmail.com,
        elena.ufimtseva@oracle.com, eric.auger@redhat.com, f4bug@amsat.org,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        jan.kiszka@web.de, jgg@nvidia.com, jidong.xiao@gmail.com,
        jjherne@linux.vnet.ibm.com, joao.m.martins@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        mburton@qti.qualcomm.com, mdean@redhat.com,
        mimu@linux.vnet.ibm.com, peter.maydell@linaro.org,
        qemu-devel@nongnu.org, richard.henderson@linaro.org,
        shameerali.kolothum.thodi@huawei.com, stefanha@gmail.com,
        wei.w.wang@intel.com, z.huo@139.com, zwu.kernel@gmail.com
Subject: Re: QEMU developers fortnightly call for agenda for 2023-05-16
In-Reply-To: <calendar-f9e06ce0-8972-4775-9a3d-7269ec566398@google.com> (juan
        quintela's message of "Tue, 09 May 2023 12:06:42 +0000")
References: <calendar-f9e06ce0-8972-4775-9a3d-7269ec566398@google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Fri, 12 May 2023 09:35:27 +0200
Message-ID: <871qjm3su8.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

juan.quintela@gmail.com wrote:
> Hi If you are interested in any topic, please let me know. Later, Juan.

Hi folks

So far what we have in the agenda is:

questions from Mark:
- Update on single binary?
- What=E2=80=99s the status on the =E2=80=9Cicount=E2=80=9D plugin ?
- Also I could do with some help on a specific issue on KVM/HVF memory hand=
ling

From me:
- Small update on what is going on with all the migration changes

Later, Juan.


> QEMU developers fortnightly conference call
> Tuesday 2023-05-16 =E2=8B=85 15:00 =E2=80=93 16:00
> Central European Time - Madrid
>
> Location
> https://meet.jit.si/kvmcallmeeting=09
> https://www.google.com/url?q=3Dhttps%3A%2F%2Fmeet.jit.si%2Fkvmcallmeeting=
&sa=3DD&ust=3D1684065960000000&usg=3DAOvVaw14RNXU52XvArxijoKSmVbR
>
>
>
> If you need call details, please contact me: quintela@redhat.com
>
> Guests
> Philippe Mathieu-Daud=C3=A9
> Joao Martins
> quintela@redhat.com
> Meirav Dean
> Felipe Franciosi
> afaerber@suse.de
> bazulay@redhat.com
> bbauman@redhat.com
> cw@f00f.org
> dustin.kirkland@canonical.com
> eblake@redhat.com
> edgar.iglesias@gmail.com
> eric.auger@redhat.com
> iggy@theiggy.com
> jan.kiszka@web.de
> jidong.xiao@gmail.com
> jjherne@linux.vnet.ibm.com
> mimu@linux.vnet.ibm.com
> Peter Maydell
> richard.henderson@linaro.org
> stefanha@gmail.com
> Warner Losh
> z.huo@139.com
> zwu.kernel@gmail.com
> Jason Gunthorpe
> Neo Jia
> David Edmondson
> Elena Ufimtseva
> Konrad Wilk
> ale@rev.ng
> anjo@rev.ng
> Shameerali Kolothum Thodi
> Wang, Wei W
> Chao Peng
> kvm-devel
> qemu-devel@nongnu.org
> mburton@qti.qualcomm.com

