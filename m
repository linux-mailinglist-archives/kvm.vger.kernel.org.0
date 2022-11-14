Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18964627D0B
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 12:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236468AbiKNLxz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 06:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236247AbiKNLxg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 06:53:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7622AE23
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 03:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668426494;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=ucfH+X8twl2Ws47Bs6a6DYYXobksfor7Ckp6hH8bzJw=;
        b=Gf/oSEzzP2RjEKks9ZgN8LF7YrFy54y++0O0vef6KYkKYGyG5DlU8lblCtw/Wyao1WoAp3
        RS7zVHmeyFsOl1b5zL4yF4AZXSTomyYjh6f9Vrl+FCMcT/cB7OH2kSVuJTLOOI5SkD7CJy
        MGoL6wCcdfRkxhkD3vCuT9uq2JxlqtQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-471-4jYFeFZeMMmBq0o7EdOcJQ-1; Mon, 14 Nov 2022 06:48:13 -0500
X-MC-Unique: 4jYFeFZeMMmBq0o7EdOcJQ-1
Received: by mail-wm1-f71.google.com with SMTP id c130-20020a1c3588000000b003b56be513e1so6664790wma.0
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 03:48:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ucfH+X8twl2Ws47Bs6a6DYYXobksfor7Ckp6hH8bzJw=;
        b=PWJXvvkOHEJuUpfeGEqlNeR8T4+5lJLA/y6Y9kHtHpnf7au+kne1wlOAs87DVPWkVX
         1RlnPPsKJup7K13UR1Nh6mMqrQuAzFW7pZ65gwUFbMvJU0og4SRDbc/YQZE0guFVGnSJ
         hKHmxYqGLF3OfijeIlmXdWZFmMmp6v1A2W6RbVBIw78TQbjE++QwdoupeduDPrcCHZ2v
         V1qni2WAx0kzt9IwHTRRfQJnSBXccSfYUYbE2Z1FxpmcU0oqL08VSoKaJ3v4bHMguzAo
         X3QvMYdnuhqISmcDVnxs8/oTunz3U++W0EuM6vTyxRm56nXJK4OxXkASddP17cqC7OhV
         09Vg==
X-Gm-Message-State: ANoB5pnM3WWUt+Pwx9/OabP7CXSfSQMZDLdVWLwZZ8IAJBYkZo2V/IhH
        mBQCp12w50gWG+UED3KgzbV/fr/FyXk+1mzpKdDF5HK0hxKQHV3TMkLV2ZIjkL1NT3hkEgUSvXX
        uv1vfKDdixMwF
X-Received: by 2002:adf:e70e:0:b0:22c:d758:6fcb with SMTP id c14-20020adfe70e000000b0022cd7586fcbmr7229533wrm.542.1668426492454;
        Mon, 14 Nov 2022 03:48:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf70T+oDUKXKgT3/zn6chPDyqo6Da2/XgYL1A0ufFkEJaA2cqrJ6CIz9B9Su0cIS62L6m6VueQ==
X-Received: by 2002:adf:e70e:0:b0:22c:d758:6fcb with SMTP id c14-20020adfe70e000000b0022cd7586fcbmr7229527wrm.542.1668426492262;
        Mon, 14 Nov 2022 03:48:12 -0800 (PST)
Received: from localhost ([31.4.176.155])
        by smtp.gmail.com with ESMTPSA id q9-20020a5d61c9000000b0023c508a1c24sm9245591wrv.26.2022.11.14.03.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 03:48:11 -0800 (PST)
From:   quintela@redhat.com
X-Google-Original-From: Juan Quintela <quintela@redhat.com>, Andre Beausoleil
 <abeausol@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for 2022-11-15
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Mon, 14 Nov 2022 12:47:40 +0100
Message-ID: <87o7t969lv.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi

Please, send any topic that you are interested in covering.

We already have some topics:
Re agenda, see below topics our team would like to discuss:

   - QEMU support for kernel/vfio V2 live migration patches
   - acceptance of changes required for Grace/Hopper passthrough and vGPU
   support
      - the migration support is now looking like it will converge on the
      6.2 kernel
   - tuning GPU migration performance on QEMU/vfio, beyond what the V2 work
   delivers


 Call details:

By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

