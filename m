Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B536AE048
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 14:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbjCGNVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 08:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCGNUR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 08:20:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6F54FF1E
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 05:18:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678195106;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=fZXlBc6lyZ1c6TnC6FQTVuc3F72zR+pjVNdoPMqVdpU=;
        b=CbY/x0ESYWtdkF5hYo3mimw0ZYb7zAmS6HcVtio9wl/KHwkQnv1699Dm8TgNSGRsIExhBd
        jzn0e01SnYev23JfkFm8BXkjJm3RcGiVRWOAlr55Wmu1tROFhg1dNeItyElWcAtjKidHG8
        dKl+DKVd93qyCK2X/W2m2L+aGOU3Ock=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-fecDEvm2MTC8KDg73QHXIA-1; Tue, 07 Mar 2023 08:18:25 -0500
X-MC-Unique: fecDEvm2MTC8KDg73QHXIA-1
Received: by mail-wr1-f71.google.com with SMTP id by11-20020a056000098b00b002ce45687cbdso1798125wrb.12
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 05:18:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678195104;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fZXlBc6lyZ1c6TnC6FQTVuc3F72zR+pjVNdoPMqVdpU=;
        b=T+jHiH3IMcmtKLEaBIiKlz2PMoITZKWPdGJB66YIMwQc9V1IuQOjPkc3w7lsiUsHOJ
         ituGuGB2XcJem5X2lJ5L4/dXp9ikw6/NdAIxSQUp5+7QpHlwMWpEnrfkB2RddA8eqaTS
         b7PBfSE4T14BO+tYiZDveE9sWy86cWqhBJfGXmFMuBebyYyPTawPbBz9Ab9ddSUbxGZ9
         /uk3/H+cy7e+hUQMHFa2+wVWfZKNcqGNzSg3V3BL8YRSfyJv5MW6Dqrkf7l0De9l0gSD
         9oCg4x/uN80oOraQ9iFcmGhWFFHfCCoFYdSRusyAafDgdmtOxDr1MW0OMPwxD7/uCjxJ
         wR/w==
X-Gm-Message-State: AO0yUKVvA9JFvmPXCEsC2rsMgtbjRNYW1iFzyZp8o8804A4p5ompEiS5
        DRdaARaceEXwLtZ82T/Xqav6fwl1eZkmm7k4FlJgQYoBb414pL6Frnupv3O+XjOpOPNXnN9atRE
        GMDmqb5kxLqFU1clKT3P08UE=
X-Received: by 2002:a05:600c:1990:b0:3e2:20c7:6553 with SMTP id t16-20020a05600c199000b003e220c76553mr12918639wmq.13.1678195103820;
        Tue, 07 Mar 2023 05:18:23 -0800 (PST)
X-Google-Smtp-Source: AK7set9qqcuKyXfe8vdjQpA9gaFeQPQjWpqpLIBNPq4OIFWyyhUZaXXjLreRGq4C5WS1fj/Pp2kzaQ==
X-Received: by 2002:a05:600c:1990:b0:3e2:20c7:6553 with SMTP id t16-20020a05600c199000b003e220c76553mr12918620wmq.13.1678195103511;
        Tue, 07 Mar 2023 05:18:23 -0800 (PST)
Received: from redhat.com ([46.136.252.15])
        by smtp.gmail.com with ESMTPSA id l21-20020a05600c47d500b003e11ad0750csm12584213wmo.47.2023.03.07.05.18.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 05:18:22 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org, kvm-devel <kvm@vger.kernel.org>
Subject: QEMU/KVM call minutes for 2022-02-21
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 07 Mar 2023 14:18:21 +0100
Message-ID: <87356gk8de.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

Sorry for the delay, some of the topics of the previous call:

Record of sessions:
- What do peple think?

  This makes things easier for people that can't attend due to whatever
  reason.  Mainly TZ problems.

- Should we do another one next week?  Which one?
  TDX migration
  VFIO/VPDA/Vhost migration
  qemu single binary


- The future of icount

icount and determism

determinism with icount: imposible
icount without determisim: interesting and useful

can we consider and icount while also doing a multithread.  Probably
yes and lots of advantages in lot of fields.


icount now simple implementation of decrementing a counter each time
one block is executed.

Now looks like a 50Mhz cpu.
instrument with plugins different parts of qemu
rigth now tcg plugins only do passive "things"
be able to intrument small things.

icount in main code only for counting insttructions.  Everything else to plugins.

Use round robin to make multithread/core deterministic.  Help with debugging CPU's.

Plugins that control the flow of time.  Is that ok with the community.

Use this to glue two emulators together?



Do we have an agenda for next weeks KVM call yet? If there is space I'd
like to take some time to discuss the future direction of icount.

Specifically I believe there might be some proposals for how we could
support icount with MTTCG worth discussing. From my point of view icount
provides too things:

  - a sense of time vaguely related to execution rather than wall clock
  - determinism 

I would love to divorce the former from icount and punt it to plugins.
The plugin would be free to instrument as heavily or lightly as it sees
fit and provide its best guess as to guest time on demand. I wrote this
idea up as a card in Linaro's JIRA if anyone is interested:

  https://linaro.atlassian.net/browse/QEMU-481  

Being able to punt cost modelling and sense of time into plugins would
allow the core icount support to concentrate on determinism. Then any
attempt to enable icount for MTTCG would then have to ensure it stays
deterministic.

Richard and I have discussed the problem a few times and weren't sure it
was solvable but I'm totally open to hearing ideas on how to do it.
Fundamentally I think we would have to ensure any TB's doing IO would
have to execute in an exclusive context. The TCG code already has
mechanisms to ensure all IO is only done at the end of blocks so it
doesn't seem a huge leap to ensure we execute those blocks exclusively.
However there is still the problem of what to do about other pure
computation threads getting ahead or behind of the IO blocks on
subsequent runs.

Anyway does anyone else have ideas to bring to the discussion?

Later, Juan.

