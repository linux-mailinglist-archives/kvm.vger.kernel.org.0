Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBB37BD39A
	for <lists+kvm@lfdr.de>; Mon,  9 Oct 2023 08:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345295AbjJIGkw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 02:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345292AbjJIGkv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 02:40:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AFAB6
        for <kvm@vger.kernel.org>; Sun,  8 Oct 2023 23:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696833600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fvnO/n22PQxXlIkcz3AgTqPmh7n0aoPnNFBUSJHK9yA=;
        b=MYGxDhLyksjw74w5Np6kDRpkBWD9ZHSsfUper1K1C9blI22IqgVDmX9bqcYaOOE/Hci5j0
        5Q25JExKM90zrIZqZKR5s7FlqnPzDqVAzuvPOoUB5vsTWAqD3WLuYe1xVN0Vz2AE/TKxhR
        DyHDuqm6EXzoWXERd6ZP6JxfsPUDqrk=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-630-D3fpZOMMNT60he9U0SCPPg-1; Mon, 09 Oct 2023 02:39:49 -0400
X-MC-Unique: D3fpZOMMNT60he9U0SCPPg-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5056cc81e30so3577580e87.0
        for <kvm@vger.kernel.org>; Sun, 08 Oct 2023 23:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696833588; x=1697438388;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvnO/n22PQxXlIkcz3AgTqPmh7n0aoPnNFBUSJHK9yA=;
        b=VLRJLBn2tyxHYO5qkLcSfRX3r9n2y0HAvD05t2kbLtPrwfOY7xLtVTVY8qudcJXc+h
         juDPj9iQOSrXr8BJYLiNi9hTghFr9E+Vb+vPHsOttPpnp7TNvwceAZCTf3morWQZ5pjc
         rgR76RKnwTj4M2QmXhNa72bhO0BfzLBuNPecscAaDB+NqyzuVX16dqiRHI185nNtys8E
         zbgZb5vFDnexHTStqHXLl74Uq8KGeKv6SBCBQ6T8d9CqehsHb5mEe+u2TsKzKUlhIffH
         SJXA2O/SbQ8l7dvRg4ryOpyhZucPqhhtCt74qaev6lLpyKXsCyqZWfUZ+/w/vYUZbvgi
         xajQ==
X-Gm-Message-State: AOJu0YztaiBtvskPzyMh7cytnofBYLHpLjdrJBnr7tXNosBoSTxBTymd
        sEm1Pw2ZfFbt2e/TsPvZZZce1MLeu0F8QqZ5SP0J0121CNtLQjL6JWTzfVp/CXXZkzd1NP/EKr2
        Jtb0JuzOKmloP4W7lsxHE0FdIs5kZ
X-Received: by 2002:a19:7906:0:b0:503:3cc:cd39 with SMTP id u6-20020a197906000000b0050303cccd39mr8935723lfc.8.1696833588081;
        Sun, 08 Oct 2023 23:39:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE9g2cnceBAdSDWl6fXeO15stoCAkJ0V/vOyY78DevlBHKAFwm8a1POknf9dcOirlNw3Ehtu0JGjOiVYMzlHEI=
X-Received: by 2002:a19:7906:0:b0:503:3cc:cd39 with SMTP id
 u6-20020a197906000000b0050303cccd39mr8935712lfc.8.1696833587765; Sun, 08 Oct
 2023 23:39:47 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130132.561193-1-dtatulea@nvidia.com> <20230912130132.561193-10-dtatulea@nvidia.com>
 <CACGkMEsC_rgnKyG3stFbc-Mz2yiKGwNUYYqG64jQbNpZBtnVvg@mail.gmail.com>
 <c42db8942523afe8bbf54815f672acd9e47cfa67.camel@nvidia.com>
 <CACGkMEvZESDuOiX_oOvMUh0YqCWYqvmD3Ve9YEJW3+RXXyvGew@mail.gmail.com> <4f9759182636f7bb3cb15bc8b6ec6afbe0d6053d.camel@nvidia.com>
In-Reply-To: <4f9759182636f7bb3cb15bc8b6ec6afbe0d6053d.camel@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 9 Oct 2023 14:39:36 +0800
Message-ID: <CACGkMEvt5B_3i1wOs2yt0KmEYPpSMd_DRJ2==xzp9eMCwww4oQ@mail.gmail.com>
Subject: Re: [PATCH 09/16] vdpa/mlx5: Allow creation/deletion of any given mr struct
To:     Dragos Tatulea <dtatulea@nvidia.com>
Cc:     "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
        Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 8, 2023 at 8:05=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
> On Sun, 2023-10-08 at 12:25 +0800, Jason Wang wrote:
> > On Tue, Sep 26, 2023 at 3:21=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia=
.com> wrote:
> > >
> > > On Tue, 2023-09-26 at 12:44 +0800, Jason Wang wrote:
> > > > On Tue, Sep 12, 2023 at 9:02=E2=80=AFPM Dragos Tatulea <dtatulea@nv=
idia.com>
> > > > wrote:
> > > > >
> > > > > This patch adapts the mr creation/deletion code to be able to wor=
k with
> > > > > any given mr struct pointer. All the APIs are adapted to take an =
extra
> > > > > parameter for the mr.
> > > > >
> > > > > mlx5_vdpa_create/delete_mr doesn't need a ASID parameter anymore.=
 The
> > > > > check is done in the caller instead (mlx5_set_map).
> > > > >
> > > > > This change is needed for a followup patch which will introduce a=
n
> > > > > additional mr for the vq descriptor data.
> > > > >
> > > > > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > > > > ---
> > > >
> > > > Thinking of this decoupling I think I have a question.
> > > >
> > > > We advertise 2 address spaces and 2 groups. So we actually don't kn=
ow
> > > > for example which address spaces will be used by dvq.
> > > >
> > > > And actually we allow the user space to do something like
> > > >
> > > > set_group_asid(dvq_group, 0)
> > > > set_map(0)
> > > > set_group_asid(dvq_group, 1)
> > > > set_map(1)
> > > >
> > > > I wonder if the decoupling like this patch can work and why.
> > > >
> > > This scenario could indeed work. Especially if you look at the 13'th =
patch
> > > [0]
> > > where hw support is added. Are you wondering if this should work at a=
ll or
> > > if it
> > > should be blocked?
> >
> > It would be great if it can work with the following patches. But at
> > least for this patch, it seems not:
> >
> > For example, what happens if we switch back to group 0 for dvq?
> >
> > set_group_asid(dvq_group, 0)
> > set_map(0)
> > set_group_asid(dvq_group, 1)
> > set_map(1)
> > // here we destroy the mr created for asid 0
> > set_group_asid(dvq_group, 0)
> >
> If by destroy you mean .reset,

It's not rest. During the second map, the mr is destroyed by
mlx5_vdpa_change_map().

 I think it works: During .reset the mapping in
> ASID 0 is reset back to the DMA/pysical map (mlx5_vdpa_create_dma_mr). Am=
 I
> missing something?
>
> > Btw, if this is a new issue, I haven't checked whether or not it
> > exists before this series (if yes, we can fix on top).
>
> > >
> > > > It looks to me the most easy way is to let each AS be backed by an =
MR.
> > > > Then we don't even need to care about the dvq, cvq.
> > > That's what this patch series dowes.
> >
> > Good to know this, I will review the series.
> >
> I was planning to spin a v3 with Eugenio's suggestions. Should I wait for=
 your
> feedback before doing that?

You can post v3 and we can move the discussion there if you wish.

Thanks

>
> Thanks,
> Dragos

