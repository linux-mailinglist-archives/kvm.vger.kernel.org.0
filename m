Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB8E4D5755
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 02:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345400AbiCKB15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 20:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345350AbiCKB1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 20:27:47 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAA619F449
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 17:26:45 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-2dc28791ecbso78281507b3.4
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 17:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KA9YZ/MGaQsalELOdrxAActwdu72Km42M2dgBlMQW0I=;
        b=i9IMsBytaLTTr9sYHJVkreJBtCBSxZ1iU0kTG+0wX2HudhdQ9bqjpr5r43jDwCKWYy
         DnJWHrt3lTbyvD26cdGAky0jqFf8LlNtf2/PNDTaftTL+aCZxxfgYAzBDp5dxLX7jkMb
         7s3YzmXn+matyTMkz6DcQ2nFzsNbzzK0I5cFPfB1Mtu3xnmg8Nd0tNX8ox99ofyOq3/2
         ME1fCdMn6mtI2yxDa1Bo8PU1Vug0eH5szAuk9w/xvwqD7dCxrBZSdlISGcufoHgLqzNd
         CNYkoD6Vykui2LhibXDH+06bzU/mRoFVHHu0tmSdO3KoygjMWJGjLXjf3gj28TrJSM2g
         Igcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KA9YZ/MGaQsalELOdrxAActwdu72Km42M2dgBlMQW0I=;
        b=6LYmmFNPvb0DowXD7dwV1DVOR/DxoDFYqIjtWrA9GDxgLyKul1aGVyMOFeXwnQlJZF
         uL2B6VHhSys+6/GLJrslescxfHwju4EGzlbOeAbZQndAmhA4GyhiFZtKkPkIke50PNk2
         vQIVSPQAkSVzL39qP88g1Z/eo+29qqfIQtKLAoSis2FnYgjBzWw9za8pzHjr5UE7horE
         IZYE0uTLxDzUA64vyObAH+pcrpBq9/NMdhM1GlrtMqrmrPOBgAqLnumY4Nn0ACOdo7nO
         wnxaS4vjQNpsiKsMsPQKOzq1STTQDatrqdLrLB4ATLEveZcZn7EjQwOjy3cj6xkyRWpI
         SYrw==
X-Gm-Message-State: AOAM531hJp5FbArck0aF7TpoWI6RaHTpJwEqDHzR2ilAI62V9gO+d7mi
        IMfKZpmgTIyWrJ/mebXibkleJXqdIOco62+VyLbvGw==
X-Google-Smtp-Source: ABdhPJxSofcm7lRCRp6xAfTgi9OIDSyZM9GgFv0Msotp0q/OKYFtxgvI7QElXdlaKgsrJFOXfsmpoTzWc9IAupp5Jeo=
X-Received: by 2002:a81:6357:0:b0:2d7:2af4:6e12 with SMTP id
 x84-20020a816357000000b002d72af46e12mr6679940ywb.317.1646962004594; Thu, 10
 Mar 2022 17:26:44 -0800 (PST)
MIME-Version: 1.0
References: <20220310135012.175219-1-jiyong@google.com> <20220310141420.lsdchdfcybzmdhnz@sgarzare-redhat>
 <20220310102636-mutt-send-email-mst@kernel.org> <20220310170853.0e07140f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310170853.0e07140f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jiyong Park <jiyong@google.com>
Date:   Fri, 11 Mar 2022 10:26:08 +0900
Message-ID: <CALeUXe7OGUUt+5hpiLcg=1vWsOWkSRLN3Lb-ncpXZZjsgZntjQ@mail.gmail.com>
Subject: Re: [PATCH v3] vsock: each transport cycles only on its own sockets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, adelva@google.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

First of all, sorry for the stupid breakage I made in V2. I forgot to turn
CONFIG_VMWARE_VMCI_VSOCKETS on when I did the build by
myself. I turned it on later and fixed the build error in V3.

> Jiyong, would you mind collecting the tags from Stefano and Michael
> and reposting? I fixed our build bot, it should build test the patch
> - I can't re-run on an already ignored patch, sadly.

Jakub, please bear with me; Could you explain what you exactly want
me to do? I'm new to kernel development and don't know how changes
which Stefano and Machael maintain get tested and staged.
