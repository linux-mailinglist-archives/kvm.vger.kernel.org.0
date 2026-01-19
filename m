Return-Path: <kvm+bounces-68456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 81CBFD39C4E
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 03:13:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6B9483009C28
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 02:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3F923ABA1;
	Mon, 19 Jan 2026 02:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eWSYO9LC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZJ5PppMM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2510238159
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 02:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768788827; cv=none; b=imCs8i3nq/f+Zrc2SDbCro7qzRNGvT4hsqup7FoXweZ8tED6J/WEk5oz5+wRqQLS35zxPWAgwWoTAN1jRyzIM/4H4+7giR6D3Wk/qpr40Nb95+V0YZzH/NkNH8IAIrJnGJJDQocI5O+k2MIoeosYIl0swb6eeKeKCAt8gxF3IHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768788827; c=relaxed/simple;
	bh=90+tWTeSxgceKDw77gnujS5MZr4uRL5NZ/GtCzmhgqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VtnpDolN4KCDxwA0FH5yox+kFXJcBWh98Qg1FDvQnx8rblw2PIGo6TtLG05ngC9aGfOAUoriGxQ95PPRHPlR8oak8iDy0z71kajqN1mv7PkGIIJ/JxLX7Bn5RKejJHTYS4qvOtHRaAYDnLTIQH3Fe0h5ylTuYynSUt/hVln24rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eWSYO9LC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZJ5PppMM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768788823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3oJ+aQGDfix+/xeXCCrELRf1tc5jPJ1TkK9gqm/2Sac=;
	b=eWSYO9LCYyuLsYGD6lVDQbOqc2gQNnc6IUO2q9w9WMJPHFJwuJ40gtD0t9a5HkYzXtG4Ef
	Nnk1l10AFm3PtJ63lSApgQCkATo6lr41wjRHIFC5NiN/aqFnV9KLkdLDsyvfNFdhtJx2jJ
	te8Wmg+7xDTWZcVqTx/x2i5X4750h0Q=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-288-3LMtaL_hOAW4cZ-BEYJO3w-1; Sun, 18 Jan 2026 21:13:42 -0500
X-MC-Unique: 3LMtaL_hOAW4cZ-BEYJO3w-1
X-Mimecast-MFC-AGG-ID: 3LMtaL_hOAW4cZ-BEYJO3w_1768788822
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-5eea3c9e00bso8687592137.2
        for <kvm@vger.kernel.org>; Sun, 18 Jan 2026 18:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768788822; x=1769393622; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oJ+aQGDfix+/xeXCCrELRf1tc5jPJ1TkK9gqm/2Sac=;
        b=ZJ5PppMMPPGLEH0qhVroaVs06LO0Xgcz2Sbs07Lphstxqcf2TiqcZm8JehuFKNJQxN
         op6PeZ5m0HqfnCu50jSmUxaIelaRI8smYsYnCtvzW/hLrG/NAFOCqXJYsL0IeoNWw1nP
         mlJQrVXmcQaKPZ44DUTO2+CE+GqF7YJQe4Zv6Ewu6xd+9yRxiY6AmJh1lg9K+zSkHrFE
         EKpHaHMM4ymqYq+Vz84UO2judiwSvUZz5mGnoGzWTb+e4NT+v+4magl3fiUvFvcgei86
         8lISdGiEaWwej0T9d3z5zcr7iFrQ4UhYI7aTIBWzZU2E+71dVMRAXN1BvcMTtWyKpEUR
         AWcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768788822; x=1769393622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3oJ+aQGDfix+/xeXCCrELRf1tc5jPJ1TkK9gqm/2Sac=;
        b=hCwYIV0VnI5mYGgKONXN/IeeECEiADgXykhlvtZEfvqQk8UvwJdrWMOtMaWj+JsO3B
         VO8CIn7LHBnwyyziOR8TOogSbSGIab6izFujauz00gjHnGrV5S6bH0hSnCx3KiyRrcq/
         Qcg1oOCPfeaEwONRw4rKo4vTHI0U1760+7tHyMD0tYjCxe4NyGvEJm4HJmpMkpioNLQ4
         Ua8FDN3N4hRkXZ8SJYw+cQ6HQKkLTypmkE9E+Dh68Ry7Fo4S+QhmkYyfV07CjqnNOhno
         V3NUDf8CS9KwgB8grQkZRJqAt2JhKF796bJOu8zG68dR5Vqq920iKaJuJXXmjhMOfj9l
         3cxg==
X-Forwarded-Encrypted: i=1; AJvYcCVQe6Sa9jb4QptRT2S1UJrnEvNWdFEHltSIv4XShv31YKryHce6G47QAsJO3VKSqRqAUoQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7hpnIZJp+Xm/bLpROFnks2EmeyDwGNJvBpNmAWePk6IO8IO3x
	xzCUwCbITcj38TfJGbh56SHUkY4JWgCdHnRt6/BeTEuLEUzMy8lZ3eITwPlRG50zmNhOt8MH5gJ
	E2Z3l5yR6NJHTeEGjy73Smmh7NjAvwZJz1nyPnQenIvrhHkKKeORIXQuWy3wnnaxiaBsJKJ2zNH
	Rl31ul6lla2rsibJBuqd4zNYRz1/wn
X-Gm-Gg: AY/fxX7Riepm/1s6G77UItkgm/fnHCNp5VHcaiwfiSS1vODOSoEx3H8mahSP8Yu3f3W
	WtoDPEA6dzj7LewPhjrBv9fXhLxWq3XlbA8dDmWvX1S9ZtbB+uml5yWccDEjJDO7kQ5qoS8fZHr
	/AYMxQK+8FoOT7H1ejpv0Nh+kieoOHehJ4eVBLPDPmH2IVeI66s4uypV7352GusRl1mUU=
X-Received: by 2002:a05:6102:50a7:b0:5ef:2457:8011 with SMTP id ada2fe7eead31-5f1a7124942mr3346008137.21.1768788821858;
        Sun, 18 Jan 2026 18:13:41 -0800 (PST)
X-Received: by 2002:a05:6102:50a7:b0:5ef:2457:8011 with SMTP id
 ada2fe7eead31-5f1a7124942mr3346000137.21.1768788821517; Sun, 18 Jan 2026
 18:13:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251229071614.779621-1-lulu@redhat.com> <20251229071614.779621-2-lulu@redhat.com>
 <20260107122418.GB196631@kernel.org>
In-Reply-To: <20260107122418.GB196631@kernel.org>
From: Cindy Lu <lulu@redhat.com>
Date: Mon, 19 Jan 2026 10:13:03 +0800
X-Gm-Features: AZwV_Qhbj0k0tjvHGTYXVGhNvx3NEFWR7H8u6guiOq5dyRYKTF-BbKnWNZiRaSI
Message-ID: <CACLfguXp+bLbYTSvc7u+tKob92gBvarD6nBZ6h38MAKSwy-4Dw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] vdpa/mlx5: reuse common function for MAC address updates
To: Simon Horman <horms@kernel.org>
Cc: mst@redhat.com, jasowang@redhat.com, dtatulea@nvidia.com, 
	virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 7, 2026 at 8:32=E2=80=AFPM Simon Horman <horms@kernel.org> wrot=
e:
>
> On Mon, Dec 29, 2025 at 03:16:13PM +0800, Cindy Lu wrote:
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
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 95 +++++++++++++++++--------------
> >  1 file changed, 53 insertions(+), 42 deletions(-)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/=
mlx5_vnet.c
> > index 6e42bae7c9a1..c87e6395b060 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -2125,62 +2125,48 @@ static void teardown_steering(struct mlx5_vdpa_=
net *ndev)
> >       mlx5_destroy_flow_table(ndev->rxft);
> >  }
> >
> > -static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev=
, u8 cmd)
> > +static int mlx5_vdpa_change_new_mac(struct mlx5_vdpa_net *ndev,
> > +                                 struct mlx5_core_dev *pfmdev,
> > +                                 const u8 *new_mac)
> >  {
> > -     struct mlx5_vdpa_net *ndev =3D to_mlx5_vdpa_ndev(mvdev);
> > -     struct mlx5_control_vq *cvq =3D &mvdev->cvq;
> > -     virtio_net_ctrl_ack status =3D VIRTIO_NET_ERR;
> > -     struct mlx5_core_dev *pfmdev;
> > -     size_t read;
> > -     u8 mac[ETH_ALEN], mac_back[ETH_ALEN];
> > -
> > -     pfmdev =3D pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
> > -     switch (cmd) {
> > -     case VIRTIO_NET_CTRL_MAC_ADDR_SET:
> > -             read =3D vringh_iov_pull_iotlb(&cvq->vring, &cvq->riov, (=
void *)mac, ETH_ALEN);
> > -             if (read !=3D ETH_ALEN)
> > -                     break;
> > -
> > -             if (!memcmp(ndev->config.mac, mac, 6)) {
> > -                     status =3D VIRTIO_NET_OK;
> > -                     break;
> > -             }
> > +     struct mlx5_vdpa_dev *mvdev =3D &ndev->mvdev;
> > +     u8 old_mac[ETH_ALEN];
> >
> > -             if (is_zero_ether_addr(mac))
> > -                     break;
> > +     if (is_zero_ether_addr(new_mac))
> > +             return -EINVAL;
> >
> > -             if (!is_zero_ether_addr(ndev->config.mac)) {
> > -                     if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) =
{
> > -                             mlx5_vdpa_warn(mvdev, "failed to delete o=
ld MAC %pM from MPFS table\n",
> > -                                            ndev->config.mac);
> > -                             break;
> > -                     }
> > +     if (!is_zero_ether_addr(ndev->config.mac)) {
> > +             if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
> > +                     mlx5_vdpa_warn(mvdev, "failed to delete old MAC %=
pM from MPFS table\n",
> > +                                    ndev->config.mac);
> > +                     return -EIO;
> >               }
> > +     }
> >
> > -             if (mlx5_mpfs_add_mac(pfmdev, mac)) {
> > -                     mlx5_vdpa_warn(mvdev, "failed to insert new MAC %=
pM into MPFS table\n",
> > -                                    mac);
> > -                     break;
> > -             }
> > +     if (mlx5_mpfs_add_mac(pfmdev, (u8 *)new_mac)) {
> > +             mlx5_vdpa_warn(mvdev, "failed to insert new MAC %pM into =
MPFS table\n",
> > +                            new_mac);
> > +             return -EIO;
> > +     }
> >
> >               /* backup the original mac address so that if failed to a=
dd the forward rules
> >                * we could restore it
> >                */
> > -             memcpy(mac_back, ndev->config.mac, ETH_ALEN);
> > +             memcpy(old_mac, ndev->config.mac, ETH_ALEN);
> >
> > -             memcpy(ndev->config.mac, mac, ETH_ALEN);
> > +             memcpy(ndev->config.mac, new_mac, ETH_ALEN);
>
> ...
>
> Hi Cindy,
>
> I realise that this makes the diffstat significantly more verbose.
> And hides material changes. So perhaps there is a nicer way to do this.
>
> But with the current arrangement of this patch, I think that
> the indentation from just above, until the end of this function
> needs to be updated.
>
> I.e. the following incremental patch on top of this one.
>
> This was flagged by Smatch.
>
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/ml=
x5_vnet.c
> index c87e6395b060..c796f502b604 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2149,48 +2149,48 @@ static int mlx5_vdpa_change_new_mac(struct mlx5_v=
dpa_net *ndev,
>                 return -EIO;
>         }
>
> -               /* backup the original mac address so that if failed to a=
dd the forward rules
> -                * we could restore it
> -                */
> -               memcpy(old_mac, ndev->config.mac, ETH_ALEN);
> +       /* backup the original mac address so that if failed to add the f=
orward rules
> +        * we could restore it
> +        */
> +       memcpy(old_mac, ndev->config.mac, ETH_ALEN);
>
> -               memcpy(ndev->config.mac, new_mac, ETH_ALEN);
> +       memcpy(ndev->config.mac, new_mac, ETH_ALEN);
>
> -               /* Need recreate the flow table entry, so that the packet=
 could forward back
> -                */
> -               mac_vlan_del(ndev, old_mac, 0, false);
> +       /* Need recreate the flow table entry, so that the packet could f=
orward back
> +        */
> +       mac_vlan_del(ndev, old_mac, 0, false);
>
> -               if (mac_vlan_add(ndev, ndev->config.mac, 0, false)) {
> -                       mlx5_vdpa_warn(mvdev, "failed to insert forward r=
ules, try to restore\n");
> +       if (mac_vlan_add(ndev, ndev->config.mac, 0, false)) {
> +               mlx5_vdpa_warn(mvdev, "failed to insert forward rules, tr=
y to restore\n");
>
> -                       /* Although it hardly run here, we still need dou=
ble check */
> -                       if (is_zero_ether_addr(old_mac)) {
> -                               mlx5_vdpa_warn(mvdev, "restore mac failed=
: Original MAC is zero\n");
> -                               return -EIO;
> -                       }
> +               /* Although it hardly run here, we still need double chec=
k */
> +               if (is_zero_ether_addr(old_mac)) {
> +                       mlx5_vdpa_warn(mvdev, "restore mac failed: Origin=
al MAC is zero\n");
> +                       return -EIO;
> +               }
>
> -                       /* Try to restore original mac address to MFPS ta=
ble, and try to restore
> -                        * the forward rule entry.
> -                        */
> -                       if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) =
{
> -                               mlx5_vdpa_warn(mvdev, "restore mac failed=
: delete MAC %pM from MPFS table failed\n",
> -                                              ndev->config.mac);
> -                       }
> +               /* Try to restore original mac address to MFPS table, and=
 try to restore
> +                * the forward rule entry.
> +                */
> +               if (mlx5_mpfs_del_mac(pfmdev, ndev->config.mac)) {
> +                       mlx5_vdpa_warn(mvdev, "restore mac failed: delete=
 MAC %pM from MPFS table failed\n",
> +                                      ndev->config.mac);
> +               }
>
> -                       if (mlx5_mpfs_add_mac(pfmdev, old_mac)) {
> -                               mlx5_vdpa_warn(mvdev, "restore mac failed=
: insert old MAC %pM into MPFS table failed\n",
> -                                              old_mac);
> -                       }
> +               if (mlx5_mpfs_add_mac(pfmdev, old_mac)) {
> +                       mlx5_vdpa_warn(mvdev, "restore mac failed: insert=
 old MAC %pM into MPFS table failed\n",
> +                                      old_mac);
> +               }
>
> -                       memcpy(ndev->config.mac, old_mac, ETH_ALEN);
> +               memcpy(ndev->config.mac, old_mac, ETH_ALEN);
>
> -                       if (mac_vlan_add(ndev, ndev->config.mac, 0, false=
))
> -                               mlx5_vdpa_warn(mvdev, "restore forward ru=
les failed: insert forward rules failed\n");
> +               if (mac_vlan_add(ndev, ndev->config.mac, 0, false))
> +                       mlx5_vdpa_warn(mvdev, "restore forward rules fail=
ed: insert forward rules failed\n");
>
> -                       return -EIO;
> -               }
> +               return -EIO;
> +       }
>
> -               return 0;
> +       return 0;
>  }
>
>  static virtio_net_ctrl_ack handle_ctrl_mac(struct mlx5_vdpa_dev *mvdev, =
u8 cmd)
>
Thanks Simon, will change this


