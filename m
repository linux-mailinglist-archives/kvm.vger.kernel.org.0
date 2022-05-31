Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1244B538CF8
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 10:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239278AbiEaIgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 04:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244912AbiEaIgi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 04:36:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C92196F4BE
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 01:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653986195;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=OJosmadwaZrcCAyKiBccF3XJ30hJPvrl748luVxs2H0=;
        b=OnzhBRPDDQNvwC3hmi9F/UA49xqSBn0P3IkPSs8f5KmZcGBO030B4GlpAZje6c3EjOhEgC
        uXKfgGcXXT2bgMXMCUg9f5XTLerqbOp3j7WcEPJ4QhAYdsTCaXomGGeXr1nXOcMVnXCkm7
        2ukh19soEQE8Gq6yRKuG/4EWD0pRZTc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-3dNthMNZPriXltj7lRZsRQ-1; Tue, 31 May 2022 04:36:30 -0400
X-MC-Unique: 3dNthMNZPriXltj7lRZsRQ-1
Received: by mail-wr1-f71.google.com with SMTP id e7-20020adfa747000000b0020fe61b0c62so1889521wrd.22
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 01:36:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:reply-to:date:message-id:mime-version;
        bh=OJosmadwaZrcCAyKiBccF3XJ30hJPvrl748luVxs2H0=;
        b=h8284FhrQdJJ3dqwZVtreTy/sbyvA6vIX1aRXhgpkMR420K2jfyfybLmHBSJlupuYL
         gw1DB2ytAav3iyRl2paJMxrcrnMteeOmQmTx47QEBRAmNP6VfWeZI1yHEGdBE2ooaUEE
         gbg63C+kCWrjQ/dgvRk5h0Ued/+/8eyAMPvQNVvVQ2Uesg7oSvZAPZx251C1q+28wR7p
         M8ckgv40L88GTAm5xbhscKQH1KreDqawAlQhIWcX97lc13ch7mKNhmKlY6OPvhYw4j1u
         Yfm07Aq1b/7EJKVNqIEHsjbzSPdtNu2/nyceZpE28PkpA1BChwrSEV9nOldxK7fdpt+I
         5Bcg==
X-Gm-Message-State: AOAM5334ryjoE8X4EFlR5bkNrVkV7v4lLTmBq9bo+Cvvy4yobYhVUwLF
        bzmgN99P/zzM8HfhKIQ23n20IMrOQtm69X54V5ypUDwkyvXFZ5Y9+lP8N95rh0PQI9kkfYO6whk
        ze5ZLTUJsycbt9LheSG+HRHSzR1gpGMluvPayEAPYDZCnrc3a1C46wEVy0mJWPFNQ
X-Received: by 2002:a05:600c:42c1:b0:397:4154:ec9b with SMTP id j1-20020a05600c42c100b003974154ec9bmr22445525wme.18.1653986189500;
        Tue, 31 May 2022 01:36:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzTsytkhZMytk+HH7vMuQ5rFSiX1wuM3O43Ah29Gk7Z56c9c1wx/DhipdMIGetj7FutBKbz6g==
X-Received: by 2002:a05:600c:42c1:b0:397:4154:ec9b with SMTP id j1-20020a05600c42c100b003974154ec9bmr22445508wme.18.1653986189254;
        Tue, 31 May 2022 01:36:29 -0700 (PDT)
Received: from localhost (static-88-175-6-89.ipcom.comunitel.net. [89.6.175.88])
        by smtp.gmail.com with ESMTPSA id i7-20020a5d5847000000b002101ed6e70fsm10236900wrf.37.2022.05.31.01.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 01:36:28 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     kvm-devel <kvm@vger.kernel.org>
Cc:     qemu-devel@nongnu.org
Subject: Re: KVM call for 2022-05-31
In-Reply-To: <87v8toxuel.fsf@secure.mitica> (Juan Quintela's message of "Sun,
        29 May 2022 16:53:06 +0200")
References: <87v8toxuel.fsf@secure.mitica>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Tue, 31 May 2022 10:36:28 +0200
Message-ID: <87czfup08j.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Juan Quintela <quintela@redhat.com> wrote:
> Hi

Hi

As there are no topics on the agenda, call  gets cancelled.

Happy hacking, Juan.

> Please, send any topic that you are interested in covering.
>
> At the end of Monday I will send an email with the agenda or the
> cancellation of the call, so hurry up.
>
> After discussions on the QEMU Summit, we are going to have always open a
> KVM call where you can add topics.
>
>  Call details:
>
> By popular demand, a google calendar public entry with it
>
>   https://www.google.com/calendar/embed?src=dG9iMXRqcXAzN3Y4ZXZwNzRoMHE4a3BqcXNAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ
>
> (Let me know if you have any problems with the calendar entry.  I just
> gave up about getting right at the same time CEST, CET, EDT and DST).
>
> If you need phone number details,  contact me privately
>
> Thanks, Juan.

