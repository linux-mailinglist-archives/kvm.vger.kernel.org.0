Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B6F7BCC00
	for <lists+kvm@lfdr.de>; Sun,  8 Oct 2023 06:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344322AbjJHE0L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Oct 2023 00:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344270AbjJHE0K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Oct 2023 00:26:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC19BA
        for <kvm@vger.kernel.org>; Sat,  7 Oct 2023 21:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696739127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YgXIUrST4qjfww2McuDOJwKPPpWN2yjtSeM4PuxFqTo=;
        b=QtbY/H+6ajcAJFXUGNJzsL1Q9AhVXRS7uu6rNuhQembwJl/KMblp7gnPipJmr5JJarxTSV
        y51Yi7JED90QAheT7TdvaQe6vWoeTQLBVOT+rQCkjMwX/QSV1NWl9ekj4Uy0TwshuCJbzn
        EChDVRCx8jNyJ1XLrFAGsT1ZYie3s1A=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-kt2hX5zpOKWnNDFGusPfqA-1; Sun, 08 Oct 2023 00:25:25 -0400
X-MC-Unique: kt2hX5zpOKWnNDFGusPfqA-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5041a72d2edso3059316e87.1
        for <kvm@vger.kernel.org>; Sat, 07 Oct 2023 21:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696739124; x=1697343924;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YgXIUrST4qjfww2McuDOJwKPPpWN2yjtSeM4PuxFqTo=;
        b=fX6nDyfXq7gRFlOiJ74YjMPKWPNHED4iQ1hcHnQv1Uv8ZrREoe6AkiQ4nnWs+VtqmI
         NDdcgoCMxGrPUe4cITJCj4NrSIvkXG+TSovSUcxc2QHbkDZVNn4PsDPnni8d0Rpj6O67
         UNWxkLhkiJYEEM207EmDyWE7JNZhm4HouXjkGcA6gCLYwR3S5yfhRH+MT+TA2naTyQfo
         fMHpnYWLIhQyCldiv+t4mLTzKn49CaN5fdcnaIs7wQS2nlF26514CEOVVmT7NfokDIW8
         I+jvptGsn1bPDr+xSMaYOXnKheppHVnwiv/cjFBEIH6GbgwTMnALG4jrlZQZ6BwQMGAq
         0oOQ==
X-Gm-Message-State: AOJu0Yy1s54mZAVxKBR/38zl2CqoXVdv3WBEZ+XlJr+zdGWJ6JUxxrLL
        lr6wkQbPnzFF7SrkiTaWkWBN+E4wF0XaitVphkTohV/zBz/2eRSy4kyVxRN+jY/CqqGJX2vp7aC
        Ip7ozSn0C9SZp0mW0yfOcHd/FPfuM
X-Received: by 2002:a05:6512:3095:b0:503:2a53:7480 with SMTP id z21-20020a056512309500b005032a537480mr12004277lfd.49.1696739124099;
        Sat, 07 Oct 2023 21:25:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEeWdUfFWd8qTGjAfwBOTZvnBRjqA4ufN1Zw9UrNaoUwkzNiy7HyX2jFaKj/vdxr6LcsgEtXpqXrOacIWb/aS0=
X-Received: by 2002:a05:6512:3095:b0:503:2a53:7480 with SMTP id
 z21-20020a056512309500b005032a537480mr12004263lfd.49.1696739123775; Sat, 07
 Oct 2023 21:25:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230912130132.561193-1-dtatulea@nvidia.com> <20230912130132.561193-10-dtatulea@nvidia.com>
 <CACGkMEsC_rgnKyG3stFbc-Mz2yiKGwNUYYqG64jQbNpZBtnVvg@mail.gmail.com> <c42db8942523afe8bbf54815f672acd9e47cfa67.camel@nvidia.com>
In-Reply-To: <c42db8942523afe8bbf54815f672acd9e47cfa67.camel@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Sun, 8 Oct 2023 12:25:12 +0800
Message-ID: <CACGkMEvZESDuOiX_oOvMUh0YqCWYqvmD3Ve9YEJW3+RXXyvGew@mail.gmail.com>
Subject: Re: [PATCH 09/16] vdpa/mlx5: Allow creation/deletion of any given mr struct
To:     Dragos Tatulea <dtatulea@nvidia.com>
Cc:     "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>,
        Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "eperezma@redhat.com" <eperezma@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 26, 2023 at 3:21=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia.com=
> wrote:
>
> On Tue, 2023-09-26 at 12:44 +0800, Jason Wang wrote:
> > On Tue, Sep 12, 2023 at 9:02=E2=80=AFPM Dragos Tatulea <dtatulea@nvidia=
.com> wrote:
> > >
> > > This patch adapts the mr creation/deletion code to be able to work wi=
th
> > > any given mr struct pointer. All the APIs are adapted to take an extr=
a
> > > parameter for the mr.
> > >
> > > mlx5_vdpa_create/delete_mr doesn't need a ASID parameter anymore. The
> > > check is done in the caller instead (mlx5_set_map).
> > >
> > > This change is needed for a followup patch which will introduce an
> > > additional mr for the vq descriptor data.
> > >
> > > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > > ---
> >
> > Thinking of this decoupling I think I have a question.
> >
> > We advertise 2 address spaces and 2 groups. So we actually don't know
> > for example which address spaces will be used by dvq.
> >
> > And actually we allow the user space to do something like
> >
> > set_group_asid(dvq_group, 0)
> > set_map(0)
> > set_group_asid(dvq_group, 1)
> > set_map(1)
> >
> > I wonder if the decoupling like this patch can work and why.
> >
> This scenario could indeed work. Especially if you look at the 13'th patc=
h [0]
> where hw support is added. Are you wondering if this should work at all o=
r if it
> should be blocked?

It would be great if it can work with the following patches. But at
least for this patch, it seems not:

For example, what happens if we switch back to group 0 for dvq?

set_group_asid(dvq_group, 0)
set_map(0)
set_group_asid(dvq_group, 1)
set_map(1)
// here we destroy the mr created for asid 0
set_group_asid(dvq_group, 0)

Btw, if this is a new issue, I haven't checked whether or not it
exists before this series (if yes, we can fix on top).

>
> > It looks to me the most easy way is to let each AS be backed by an MR.
> > Then we don't even need to care about the dvq, cvq.
> That's what this patch series dowes.

Good to know this, I will review the series.

Thanks

>
> Thanks,
> Dragos
>
> [0]https://lore.kernel.org/virtualization/20230912130132.561193-14-dtatul=
ea@nvidia.com/T/#u

