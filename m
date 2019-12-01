Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80D7310E3A5
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2019 22:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfLAVkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 Dec 2019 16:40:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34533 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726982AbfLAVkf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 Dec 2019 16:40:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575236434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tG5TIZfLOA8xt1lh5rIij2KaaBjofpenlumD9fhRM3E=;
        b=AyFso0rNVXN6qyAcTA6x1rXijuJjzSp9wBkyWV/TJBRE0qLJySQSm2fNLSpIZOR3eA9v0A
        ZLFVa2EieH7MMzFap4pajmlIknUjcjb89oLZnYeeeehsnuu+Q9N9+cousk13/gfXJqO48/
        sFaBuQ/LFeoElggtJzqNVzE2McR8TyM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-o0L1C_rNPGySZDcWISz68A-1; Sun, 01 Dec 2019 16:40:31 -0500
Received: by mail-qk1-f197.google.com with SMTP id q13so18882204qke.11
        for <kvm@vger.kernel.org>; Sun, 01 Dec 2019 13:40:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JTGzgGPMZkAos2frxTFOW4GGlQLGb9Frjb4++KqTi/M=;
        b=IVrxdD9G58ZWAO2fdsjGdZbDKY31O7bT2kO5vHUo40jiiu6CSOh+afryuU9vqkuMfT
         9KJWDjJWZVcQerW6isj5vTtinIY9iuaHPhlOmxo1Wu3tXAk/40ugxxyjEt6s4vTLJfPL
         3ebV3aSTwN5z8rvG4y5UB33Etn/Hv1mzVWf6unWohs9ashnpAJqJ0oH/jpY7qXcckzIu
         TS1UGDM96blWiNZ5jQ5jb83IdY2SzDbL+qGwGc15wCYx9Uyko/auIk98440jRCyj7IgS
         nY1IJB0udsV7/CgTNWVFRugFXbn9nw73QgHrMBXXMKFVooyNNMmFiEzknxEGBEkFBtYE
         WH/g==
X-Gm-Message-State: APjAAAVB5+rbLVEPVbvVo9k7v9PiUqgCKlJZSPLXMAnTOcevVXwugL1D
        ZicqTblIG0uEP57EW4mOJNvyOB+LuUu7S2aMwPlyJW10/HIdhKLckGo17h1SWZ8ineS27rMzkN8
        ccyZNgf5I8HgT
X-Received: by 2002:a0c:9304:: with SMTP id d4mr20056112qvd.12.1575236430595;
        Sun, 01 Dec 2019 13:40:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqwJvP9j5S9q3Ge/KOdZS8vWQSybrc86pCylj6ImGZeLhx1dUelTS/voklZcfzNpx7tuR/qMng==
X-Received: by 2002:a0c:9304:: with SMTP id d4mr20056096qvd.12.1575236430400;
        Sun, 01 Dec 2019 13:40:30 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id r48sm15329424qte.49.2019.12.01.13.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Dec 2019 13:40:29 -0800 (PST)
Date:   Sun, 1 Dec 2019 16:40:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     dsahern@gmail.com, prashantbhole.linux@gmail.com,
        jasowang@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [RFC net-next 08/18] tun: run offloaded XDP program in Tx path
Message-ID: <20191201163730-mutt-send-email-mst@kernel.org>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
 <20191126100744.5083-9-prashantbhole.linux@gmail.com>
 <f39536e4-1492-04e6-1293-302cc75e81bf@gmail.com>
 <20191201.125621.1568040486743628333.davem@davemloft.net>
MIME-Version: 1.0
In-Reply-To: <20191201.125621.1568040486743628333.davem@davemloft.net>
X-MC-Unique: o0L1C_rNPGySZDcWISz68A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Dec 01, 2019 at 12:56:21PM -0800, David Miller wrote:
> From: David Ahern <dsahern@gmail.com>
> Date: Sun, 1 Dec 2019 09:39:54 -0700
>=20
> > Below you just drop the packet which is going to be a bad user
> > experience. A better user experience is to detect XDP return codes a
> > program uses, catch those that are not supported for this use case and
> > fail the install of the program.
>=20
> This is not universally possible.
>=20
> Return codes can be calculated dynamically, come from maps potentially
> shared with other bpf programs, etc.
>=20
> So unfortunately this suggestion is not tenable.

Right. But it is helpful to expose the supported functionality
to guest in some way, if nothing else then so that
guests can be moved between different hosts.

Also, we need a way to report this kind of event to guest
so it's possible to figure out what went wrong.

--=20
MST

