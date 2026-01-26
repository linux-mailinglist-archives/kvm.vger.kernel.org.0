Return-Path: <kvm+bounces-69080-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wPxpMwwgd2ntcQEAu9opvQ
	(envelope-from <kvm+bounces-69080-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:04:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 555AF85400
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 09:04:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 400FE300CC3E
	for <lists+kvm@lfdr.de>; Mon, 26 Jan 2026 08:04:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB6C52F7462;
	Mon, 26 Jan 2026 08:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cYR+TB61";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="JuDWv+bc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417BD2BEFF8
	for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 08:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769414649; cv=pass; b=Bqg/aqqJwKAdjBMGgxvz61EgXpej40NOdFOvVAPtidDWu7cLjruF0B3mibEWjwW9mGqP+aE0eL78Vq6KauFuStj2wIen9xeqxtf3OzdQ4gdDLRshLYDcYyZDlrPpcNfSSFcUPBREOE3/4vifPpRNBG8l88Ktzh4v3gk99pBkrdg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769414649; c=relaxed/simple;
	bh=CWGx5SwOqaT/YlaB3Ps9+tQ+33m439GlJ4rNP6yIH50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cpk/w8GC/eTdDbcHX3oR+HeqrXYjhXmkEnx8lydZaLWjrWrx0ibB9JEvD4AHMa66/4lzOjXv/sBd5QdeJRAPC7P3Uk+eA+GjTJYB/2tKz8tmV7/MmzaKmXxkHGv1bggvQn8odFs8gG4P3X6uw08bQwu7XGJ5+3a9wcAI92/7o7U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cYR+TB61; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=JuDWv+bc; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769414646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sZQZQO2mxRCQriV7DA3Ln3qIIcNBZotCw5GdvUiDLcg=;
	b=cYR+TB61whsrhpPlhsZdy82K6780alQ8kRZ1tPoHvFhbuq+Tw4qSDlumGeP+K0VVrXGOdf
	ZJoY2B/UDatUdcamIr0MokrBQAwT14egFZQ8W/DQ9zteblys+vAxbBcriEbmzeYsRLLO8I
	7NlRCT2iZZvhV7LT6zw6/nFFUASc6qk=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-126-iBy0aPevNtyW621133ffjQ-1; Mon, 26 Jan 2026 03:04:04 -0500
X-MC-Unique: iBy0aPevNtyW621133ffjQ-1
X-Mimecast-MFC-AGG-ID: iBy0aPevNtyW621133ffjQ_1769414644
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-9483c03078cso9297402241.2
        for <kvm@vger.kernel.org>; Mon, 26 Jan 2026 00:04:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769414644; cv=none;
        d=google.com; s=arc-20240605;
        b=dzeWWsehg6XGewsgM9kGS01QIkTWM7s7nooiXT3g4VayNOWXrnAJX1m5fabkP0LBnB
         QAFDzqjgqOn/pFQ9pc6LGoCW/Plua1nOryU6ZJni8rUoQNkmEGRTNUkOU+BrfX/6pK4Z
         ZkLlY12L22CVlFDOHspERiXpNOt18z2cI9MThhrQsFj6TWwmA470NMPK8LWB0NVjc3iP
         AT1VcO5KqR77M2LVHGGjS6+YJulmbTXeEYCikTp0R3MHwiMXau3xMdcVaVYFq8x9JQ7f
         jRG+MmKI2hiTman8TWPrUxW0zBkIy659UuhtgqLGWJuh2VehbMwaQ4viWAUiJm2baiJ7
         idCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sZQZQO2mxRCQriV7DA3Ln3qIIcNBZotCw5GdvUiDLcg=;
        fh=FY2Iq8OyEdiDXv5vw0tXKb3FYFaKgZqj10DGlpgvdE0=;
        b=gTatOcFHztUYqQ0EAGXMyoTAVHyImgKj1IejCIT2B+Ymln9YxK5Kj/RihlLN17hR9X
         LNPgvXDGPoUlr+u8lafUlgCP7xoZEi+J+aeFrd37FQGJdZ8/D0kmOS86T1aHXJpz+wQ1
         ooTt1A1SuG0vnPKNnRVxhkc8ROcz5xtSLbzA7TKvVIgkvXIupDZ5gBwKCp0aYF5I8TEL
         q0A2Jzh83BNdl3UXjkp3sUDSCUPQtdN2jZ+ESBZwDyRHdp/EXiHz2aqAMHc8sbYF9mH0
         wynY99WTVvOrPeeb3+Bd7idFLH6XFfyZJKeuKm++kZuGLCRiXsHRcXx/Lp6ro2hMP4Br
         xLTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769414644; x=1770019444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZQZQO2mxRCQriV7DA3Ln3qIIcNBZotCw5GdvUiDLcg=;
        b=JuDWv+bcP6ADImm1z8JAVSCcOI2wd5SS1rB5j/KuS+1M5SMp/7gii+JRTBiJuRxhLe
         JCfg4d9KNLsAgGGskKh3M15TyT3hMqV/uG+RlQqIpCHWkuLJboZMZx8TZjkVvTFe/5Zg
         2bk0Qu4kxS53vv/FxcQnLA8zMGcwR6n06snz+VInpBbVx2M+IxiBvq1YIAIgZeCkTk5o
         p2+DPyQkl/c0ZgPxRGQ3idpqXinaPqwIeVwHT4Ep1koPly0p26s1egHX10T0AXTujktg
         ANb65p9bAPFfeDlZconLDzkjmv8akbKMPwHdYege/mAt0EFXovawsMwqNImtPu1oF5bx
         ntrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769414644; x=1770019444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sZQZQO2mxRCQriV7DA3Ln3qIIcNBZotCw5GdvUiDLcg=;
        b=xUFfoKQGqmZ/p8Hd2AcVqB5MWf6QOUscCPe7dOfnbp5QdBd1y8OI3fpPt883yC7fWT
         rrvUppU+ScAw6qKht8b1h5LGBPOlYlz7A37h6h2YXVAQcHvO00o8ExQ2tGgofmatkJP/
         OWmvDHlV5xRV15I7HoBRnsUXF4ewyivIB2JII3b1dCSzAQk241fCkE2DZrsRqTOR0T2U
         PpWl/Vv4VjVci47F3VcYoEiNNaz/9Q5YDAZCi6eRlekdwB2TtoLRIKPuEwdouE5SO4Vh
         KLnCFY6f7MKCCxuiPtH9WhRI/CRp9bw8ZLSBNcIPzZmnMHx88G0ohzADn09gNG9rx3Bx
         zQGg==
X-Forwarded-Encrypted: i=1; AJvYcCV//oxM4GLTOUmqAJjonyby3DQL3eJ6dCEJW7Bb9xsP0OnGn9UFKr/CVBsAEzXBaraRUGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxddv35muU5HId+/ERJm/aSeV/jB4o0IWxpTYcU0ERONCG71DXr
	sL5MSg58zx3Xc53rN9rLgNsGDmrjgCBzznqMvIwtoI0YXIy/sUfgUXO+hmIaekHw204qpigDiE3
	hjP9POLS/ziDtKmu+OAOADJZH4UBG199uGbaoY3B4KNz30r4jOmAoNMF+5V0IjL7cgDy1fUK4QF
	PADn4L83GqakOEq3mXLcAF6RRTLN2P
X-Gm-Gg: AZuq6aK8G1GTFbP6iGoWsE63c8ygeAPwn93pYZ/3jRcUIi8oeUl7xitquuhI1R3r0iF
	zef/nBIMofVN1a9IEWGPBm/CGUcC2BLjXgVzefGkGVxFKpnePo3btDXhJiGCF+C1TjhUL0l4/o9
	y//uAYCSduZ8FmI6FzwY1Uq5odbxfxf5lET+1H6udaefygNhmb4HhvCXtmKU78/GLUMvU=
X-Received: by 2002:a05:6102:32d1:b0:5f5:48df:b869 with SMTP id ada2fe7eead31-5f57651cce8mr1098108137.44.1769414643919;
        Mon, 26 Jan 2026 00:04:03 -0800 (PST)
X-Received: by 2002:a05:6102:32d1:b0:5f5:48df:b869 with SMTP id
 ada2fe7eead31-5f57651cce8mr1098098137.44.1769414643588; Mon, 26 Jan 2026
 00:04:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260119055447.229772-1-lulu@redhat.com> <20260119055447.229772-3-lulu@redhat.com>
 <aW3JstEHDXjj80OL@test-OptiPlex-Tower-Plus-7010>
In-Reply-To: <aW3JstEHDXjj80OL@test-OptiPlex-Tower-Plus-7010>
From: Cindy Lu <lulu@redhat.com>
Date: Mon, 26 Jan 2026 16:03:24 +0800
X-Gm-Features: AZwV_Qixdd4SbLBwLRkXMVFpsz1u-BKiGH2rTPLdxtlyFEEtvuaiAvDni2PEalU
Message-ID: <CACLfguVXA6mpx6FUS-gwuXs0treNn_-D_-cxxAnwUD=mmztccw@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] vdpa/mlx5: reuse common function for MAC address updates
To: Hariprasad Kelam <hkelam@marvell.com>
Cc: dtatulea@nvidia.com, mst@redhat.com, jasowang@redhat.com, 
	netdev@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69080-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lulu@redhat.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[marvell.com:email,mail.gmail.com:mid,nvidia.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 555AF85400
X-Rspamd-Action: no action

On Mon, Jan 19, 2026 at 2:05=E2=80=AFPM Hariprasad Kelam <hkelam@marvell.co=
m> wrote:
>
> On 2026-01-19 at 11:23:52, Cindy Lu (lulu@redhat.com) wrote:
> > Factor out MAC address update logic and reuse it from handle_ctrl_mac()=
.
> >
> > This ensures that old MAC entries are removed from the MPFS table
> > before adding a new one and that the forwarding rules are updated
> > accordingly. If updating the flow table fails, the original MAC and
> > rules are restored as much as possible to keep the software and
> > hardware state consistent.
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> >
> > Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 131 ++++++++++++++++--------------
> >  1 file changed, 71 insertions(+), 60 deletions(-)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/=
mlx5_vnet.c
> > index 6e42bae7c9a1..7a39843de243 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -2125,86 +2125,97 @@ static void teardown_steering(struct mlx5_vdpa_=
net *ndev)
> >       mlx5_destroy_flow_table(ndev->rxft);
> >  }
> >
> > -static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev=
, u8 cmd)
> > +static int mlx5_vdpa_change_mac(struct mlx5_vdpa_net *ndev,
> > +                             struct mlx5_core_dev *pfmdev,
> > +                             const u8 *new_mac)
> >  {
> > -     struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> > -     struct mlx5_control_vq *cvq =3D &mvdev->cvq;
> > -     virtio_net_ctrl_ack status =3D VIRTIO_NET_ERR;
> > -     struct mlx5_core_dev *pfmdev;
> > -     size_t read;
> > -     u8 mac[ETH_ALEN], mac_back[ETH_ALEN];
> > +     struct mlx5_vdpa_dev *mvdev =3D &ndev->mvdev;
> > +     u8 old_mac[ETH_ALEN];
> >
> > -     pfmdev =3D pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
> > -     switch (cmd) {
> > -     case VIRTIO_NET_CTRL_MAC_ADDR_SET:
> > -             read =3D vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, (=
void *)mac, ETH_ALEN);
> > -             if (read !=3D ETH_ALEN)
> > -                     break;
> > +     if (is_zero_ether_addr(new_mac))
> > +             return -EINVAL;
> >
> > -             if (!memcmp(ndev->config.mac, mac, 6)) {
> > -                     status =3D VIRTIO_NET_OK;
> > -                     break;
> > +     if (!is_zero_ether_addr(ndev->config.mac)) {
> > +             if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
> > +                     mlx5_vdpa_warn(mvdev, "failed to delete old MAC %=
pM from MPFS table\n",
> > +                                    ndev->config.mac);
> > +                     return -EIO;
> >               }
> > +     }
> >
> > -             if (is_zero_ether_addr(mac))
> > -                     break;
> > +     if (mlx5_mpfs_add_mac(pfmdev, (u8 *)new_mac)) {
> > +             mlx5_vdpa_warn(mvdev, "failed to insert new MAC %pM into =
MPFS table\n",
> > +                            new_mac);
> > +             return -EIO;
> > +     }
> >
> > -             if (!is_zero_ether_addr(ndev->config.mac)) {
> > -                     if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) =
{
> > -                             mlx5_vdpa_warn(mvdev, "failed to delete o=
ld MAC %pM from MPFS table\n",
> > -                                            ndev->config.mac);
> > -                             break;
> > -                     }
> > -             }
> > +     /* backup the original mac address so that if failed to add the f=
orward rules
> > +      * we could restore it
> > +      */
> > +     memcpy(old_mac, ndev->config.mac, ETH_ALEN);
>         can we use "ether_addr_copy" instead of memcpy?
> Thanks,
> Hariprasad k
>
Thanks  Hariprasad, will change this
Thanks
cindy


