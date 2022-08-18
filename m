Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FD65981D5
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 13:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244222AbiHRLCd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 07:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239816AbiHRLCc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 07:02:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAAD98C90
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 04:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660820550;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type; bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=Q6bZsIjnhyuKjHcAbtP40IH8dM6Zx5WTBlyaLLKG7pEiDfRC1X+H4XICYxcGBq9AtoEUyz
        TYESVkn3rG4DbkrW5x2KDF12YXU21MHTWjRXxo8ScP2c3o9YvZ2e6bjhODn1iI1Bq5Mnoi
        4KAH20TajLA+dsztfuEQwLqV7BmTnb0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-137-l8LPZ_2OPxy7ZVPjSmuLFw-1; Thu, 18 Aug 2022 07:02:29 -0400
X-MC-Unique: l8LPZ_2OPxy7ZVPjSmuLFw-1
Received: by mail-wr1-f72.google.com with SMTP id r17-20020adfa151000000b00224f8e2a2edso166497wrr.0
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 04:02:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:subject:to:from
         :x-gm-message-state:from:to:cc;
        bh=aHw0WHUDjplHhyM2x7z49ozQEApYFi2qNDHdSE7wkJ4=;
        b=qrFFGyZgDmM3UawGmb+B1hOF0/0yuZPNexWzQRy7wPN9sbjFSyaBX0GZdfTY6Fy9GP
         Cw/afbhsbzreEr30OYsgnjQEp7NGV0dOhK2rruAsdUszr9HQrgxsY4z/pCQT5F6Zme8T
         JwByNBI+/XVAL6SZTS2siLkrU26eFI+1J9zNqrWxzwQi7+lb9eUGneAiTu7ZjtylGPMG
         W6jOhw/wEhE2WbyvsPIhIPLYWeji9qvZ08ZU27Lns1lgmVwT1FJRnGGcKuaCFotAzcBu
         ra4Lq6MhovvqwXc8FqteSgd9ptUSxf3aqYaDOpQ/Qqk/SwCxtV0m8pXYVwQYNevk5M0n
         RXVQ==
X-Gm-Message-State: ACgBeo1MSih1+x6ucFkIKeu1gPVQhvrjhkAopOEF6JDfCMNmPxM4TOgC
        Tk6l0yDXKjMGmVj6nVpp/EXnHWh+UEhhnKt2gVsWOiODNXu92W1KgtsTi/I51VVIEQ13CdSdjSt
        k5HrF0rsDnKucNFmj+8BbqADH+Zw6gGc6aure4dHnsrHWVRAVN5pf+su7LTtCMNPb
X-Received: by 2002:a5d:64c1:0:b0:222:ce3e:bd35 with SMTP id f1-20020a5d64c1000000b00222ce3ebd35mr1282032wri.520.1660820548126;
        Thu, 18 Aug 2022 04:02:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR44+Jfvs3ZHgQq+TEikGcHkyQ2Q3MyypepDu4zzVdayLzW0gDPNsDVFT78646zxeRPBclu1zQ==
X-Received: by 2002:a5d:64c1:0:b0:222:ce3e:bd35 with SMTP id f1-20020a5d64c1000000b00222ce3ebd35mr1282018wri.520.1660820547862;
        Thu, 18 Aug 2022 04:02:27 -0700 (PDT)
Received: from localhost (static-205-204-7-89.ipcom.comunitel.net. [89.7.204.205])
        by smtp.gmail.com with ESMTPSA id z11-20020a5d4c8b000000b002252f57865asm1168649wrs.15.2022.08.18.04.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 04:02:27 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>, qemu-devel@nongnu.org
Subject: KVM call for agenda for 2022-08-23
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.1 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Thu, 18 Aug 2022 13:02:26 +0200
Message-ID: <87pmgx24sd.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Hi

Please, send any topic that you are interested in covering.

At the end of Monday I will send an email with the agenda or the
cancellation of the call, so hurry up.

After discussions on the QEMU Summit, we are going to have always open a
KVM call where you can add topics.

 Call details:

By popular demand, a google calendar public entry with it

  https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ

(Let me know if you have any problems with the calendar entry.  I just
gave up about getting right at the same time CEST, CET, EDT and DST).

If you need phone number details,  contact me privately

Thanks, Juan.

