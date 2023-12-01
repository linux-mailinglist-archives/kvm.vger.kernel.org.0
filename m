Return-Path: <kvm+bounces-3132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D54D9800E8A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:26:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 39025B21087
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 15:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641ED4AF6A;
	Fri,  1 Dec 2023 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="a9Q2SBIe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC01FB6;
	Fri,  1 Dec 2023 07:26:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxmez6Uw3de9Fue8Lk4PIau9UVQ8IpcMO0Q4FQ22gHcBa0CAOoGd+L16oluO1LGMrq6JxUQ309FjqyS2kSOO00t46s3G2Xy+0J7rRjtMmRe4YJXm8SmipD+RhXXY3q+RmXEyxRgBfGYxv/sPdZVGVlSiUk+MeZ3IblqNxJIon/Tn5nuQ8OXml+PeaxKMwxuB1UPpUaCNrPiQKiiwXNn8KLGOYNAP/QLO86zd0wuVgdQRl8BD/f9bxEF7NM6yAQVhWgmbZNLjyz+tGDAGS802XeaAfJuzzDisUwRHfUWUwm6TfcY9aB8/WuBqHf6W3fW+dHuG1HPN6w8dtB7EFfcV1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HfbQe3DVIcBpWk5fwFs7qR+YU6lZ9oFZruAXg+ICt8=;
 b=KOYF1lGBrtD/MDF9L6RoZVv8JpibLwng8LgV/dSGQ5f9gB1kWdCinTh40i4zPxeutPBX/GTg6T7TFMkoH5t+cBqqvoOoVEJD/568S0+mGcPqZ59fnqrsDKGfBY7h30BeVh8bU7FH9s9i687TDAX1a+wvgrJipdMnjh76evHBvNUMWtdIhTAu7u3h9NOyWmj9s10gVk1UoMrgP30g+dMVsBz5fCM083p2fsYQrazLo7Un1jky3GWubR/XMNGTbv/unQ1OLF7MzYRe0HAdP8Yu0rKzQufLsA/kDLaGMpi8LJ8wLO+mncMXZ1y2j3Ov/jMgtCK6hgT5aWSGG81RwefJQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HfbQe3DVIcBpWk5fwFs7qR+YU6lZ9oFZruAXg+ICt8=;
 b=a9Q2SBIejLcUFTnadp0fGVLd41qMnar7kmZ1R3vYrz4bseXUjGaPaRRAutosiJw1KsN/0KJSRwu0gqPYlQfNR/tYhVLwQNVaI/YSd2NCA576/z7ClF/brMOnXg+GPFDzE9q+5xPlystsTpifWD6RMoEDjGD4gS0aA1+eqIayKrv0H8HsugntF/9AUU4qOnyanZtvIeJEdUnRv/G+NuCvUdNtVXcVB34RBW4IlAM6uwkGQvsYKQzfxVqnFhyO9OZ9ZLO5n6px1gqQaAhsCIu6o1VPh5CRw5nPh5STqwU06uygc3EEM06MsXWn+i2Qf7PuZ8vv+Bg762eNgFZkwjBQqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by BL1PR12MB5377.namprd12.prod.outlook.com (2603:10b6:208:31f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 15:26:38 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::bd76:47ad:38a9:a258%5]) with mapi id 15.20.7046.027; Fri, 1 Dec 2023
 15:26:37 +0000
Date: Fri, 1 Dec 2023 16:26:31 +0100
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Eugenio Perez Martin <eperezma@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Si-Wei Liu <si-wei.liu@oracle.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
	virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Parav Pandit <parav@nvidia.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH vhost 3/7] vdpa/mlx5: Allow modifying multiple vq fields
 in one modify command
Message-ID: <ahb5gkmzvempjyty4p767lkbwbmwj64vnhi3xpsgweqn7mvhmx@73jqxye2icd6>
References: <20231201104857.665737-1-dtatulea@nvidia.com>
 <20231201104857.665737-4-dtatulea@nvidia.com>
 <CAJaqyWe_VZ8CsG5j75oAD1FdNi7dc4rLJwjm5AoQNBm4ABfAZA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJaqyWe_VZ8CsG5j75oAD1FdNi7dc4rLJwjm5AoQNBm4ABfAZA@mail.gmail.com>
X-ClientProxiedBy: FR2P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9b::7) To DM6PR12MB5565.namprd12.prod.outlook.com
 (2603:10b6:5:1b6::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB5565:EE_|BL1PR12MB5377:EE_
X-MS-Office365-Filtering-Correlation-Id: 79d72bb2-493e-47fe-0611-08dbf281e8e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Joo01kWsrXYQ4RC9vhWlPTeMBKz5nUnUWPDEypPBysCrwS6wZn9HhRFr37hMihcPBmC7Jc1bxFCDZYf2DfSGWAVjSuFyzhcdUP8JyRa2orc79kICpYAGoBIC02Noniyq3it4jff+DuN3QeQ/aGq2yR89no8pGVapNCcwGsPTTAb5vME8YmnVbG39jiTKEWVq6h3ZVQaK7uEclbGdJbvfV2L0HuaiMbvzZnw2W0tsyurKuJAGRXuc6rUkNF29eAHZfPmMvsK5tCQM2WfPYShF0RebqXXTObDA5lL4M/Ys5HuTn2bTRg/1/G2NkylJHAUD2Xw6cj6hDZ7uX4IMlwVkzRtIQRxIntYxMLS1mtvggN9k/enXhJkTHpSePYUxfMdudQ63qYFnWJdpmrVYfhiFQ6JMHoyyY6VPnftsxodPLF0Daa/l3JufmXC7qfskWvYeAaVprCghw8dsHkZsfuML4NeeJeTMEuqGA/JCr+sVa0cTCEVa2xlEV4FZtyK99qWLGcWW0TlKpWT6OSaE7nRh8lgTL1I+p/o/2aaRtMmS7JA/FOCzX510d15V0XtITqYa
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(396003)(376002)(346002)(366004)(39860400002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(66899024)(83380400001)(38100700002)(33716001)(86362001)(66946007)(8936002)(8676002)(54906003)(4326008)(6916009)(66476007)(66556008)(316002)(5660300002)(2906002)(53546011)(6512007)(9686003)(478600001)(6486002)(6506007)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Zk1oUDNSa0VmelNCVmY2VFEyVGE1R2MxT2x2RjdkeHU1MG9BRUV4WEcvb1g5?=
 =?utf-8?B?VWVQSExWS25aQ0xkaUU0TG9kZnhPMlVoaVF3bnVSSUVacFhRTkxzUGpCZVk3?=
 =?utf-8?B?Q0QyWFBsYW5DRXBpOVVtdGxYcFl6N1lBR3R5L3M2MVdZS0JqYVhPQ0ZqU0R5?=
 =?utf-8?B?Tk5TSHFoZlpmMmphZnNidS83US9FZ0cvVE1SVndsWDRLRXU1czlDeGcyc2RM?=
 =?utf-8?B?TWc5VGlUSlhRdk1sYmNYRHc5MG5oa2RhRG13aldqcTgyZXpBMjNsZXlDY0lL?=
 =?utf-8?B?ckV4T3hBSTBmM056TlAwYURuckJLWWZaSTNxSk1SVGlTQ0dyN3FPZEpheWhP?=
 =?utf-8?B?VnpUQ3JiSjNub2hSaFNPbk1xWXhBSUpkVlIyci8wYlQ3dTdrMmNMWk9jbGpk?=
 =?utf-8?B?ZjZlSE5uV3RPMTlWQUpWazlLeDg0VnhQNEpjK2VTUHRia09uNVY0T2xxeXRS?=
 =?utf-8?B?ejRQa3dueG0zTm1lSjNhanJZc3ZnR1NsZ1pycnA0N0lSTGNMVjBRUjFXSkgy?=
 =?utf-8?B?ME5DTEpNODlOZXZoQURaRTJ0WnZYNDNENUU4UitFMmxPelRoVEhkbWlMRFV2?=
 =?utf-8?B?dGlsNzUvSVhlMURYZXN4VW5mbTNxc1p4eUQ4MllBYXcybC90L1p1K05rSVNw?=
 =?utf-8?B?d01yb2ZVNUJrQW5idWNNSks3c0twOXpZaEl2S0VId3NMNFhqaU85QytmQ2Nt?=
 =?utf-8?B?eW5qRTFZRWpTK0tubGNSb0s1dG5icEVUMzBtcHl1aXJ2NERCbHlqWGZRQkR3?=
 =?utf-8?B?T0hhVlNqZEljVlJzWU1NZFBTQlhhcW82ZW8rTGVKWUljUXVFU1I0eFB4R3hK?=
 =?utf-8?B?UWFGNUlqN1hLY21neTlIeHJiejc1Mk9rUHgwak5nTkVEYWFuNnUxR1gvZ2tt?=
 =?utf-8?B?eWZaRTdUZVhvMjVJK0dVMnNmM1dTdnlSSTBQT1cvKzk5RUZ6Y2JvK0pwR0pu?=
 =?utf-8?B?TEZwU1JlL0d4RjNTYklQSGVBWVZFOXFTUGtLdmdmOEFqckhaeHBsNFBBZnhX?=
 =?utf-8?B?SCtwaWYwT1BQb3hQRXQ3Z0pIWlU1dTRlV0FuSHV1WjNiTkZod3hsaEVYcEtk?=
 =?utf-8?B?OFR3RGVMYkxqTEdhL2tGdzVCVW9jOEZ6ZE5xZFJYYVhCbG8yYlZqU2N1ZkZ0?=
 =?utf-8?B?RndtVGk4azJZVE9iN3hmSVVXTVNHUW80RHhnM0ZGS1FpeTdCc0p1V0RBZStp?=
 =?utf-8?B?YWhUbmxqV3lubzlpWElFSHVFODV6bmI4T1JSK0s1a0xHK0szYkttTHJFMThl?=
 =?utf-8?B?R21raEhjUlRTVjZPM1p4TEttVGxOVldyeGtHQVFSek9IOXNMdTU2YUlRa090?=
 =?utf-8?B?YWhSb0tXeTFNcnFQK0pkS1VzN08xRThNUytUNCtZZERuaE1Jay9DeHlXbjg2?=
 =?utf-8?B?M25WbThmWVgvUE4remxxak5oTHV0SEFocTZqNkRtTjhZdmhrTHZQc1EzVFhR?=
 =?utf-8?B?TkJBcmNKRnFHb1NTZHRrRzl2ZzEwa2x5b1YzTnoxZnhEdEp1UFRLK2V1RnlP?=
 =?utf-8?B?R3MyTno5OFBKNHhuVW90SkZ4NjVvMjNpM2RzK3NYSXhQRkQ0V2ZHNVR1RUNO?=
 =?utf-8?B?QkVUTmI3eHgyQ1c3NTR3T0xjenFkbmNVRk16cElFdlpnbFdqazdYN1FZS2tr?=
 =?utf-8?B?ZzJBN3cyYkdVODBPLzQwWkFtbUd1WHZpNTlGV29GREt0OGtPVU9xQ3RoMDhB?=
 =?utf-8?B?R2dSbnJZa0QxVzJTVWJ6ZFhJNW8rdmlvbmEwRm5QOFVzN2RrNHV2bXAxUlY5?=
 =?utf-8?B?MHZNV3REOHE0V1lwS2JhQ0JhMlNtWmJ3SUkwVWRzZGp0ZDdvRytHMXF3TDdr?=
 =?utf-8?B?cmoyclVOUDV2OFB4VWpEb3J0cG5ZQWhQWXpLOGJPTHZQNlN0OVRGVUtjVDVl?=
 =?utf-8?B?Qyt0R2hxb0NTUGF3NGhlc3ExQnV6cUdUN0IzVGtRNW1JQ2xzMUhpeWs1QTZD?=
 =?utf-8?B?MUZEaktocE5aRGZ5ekgxaHRGWFpFcXdZZnpxdGhTc0NHZ2FWQ215ZjNKcWw4?=
 =?utf-8?B?c3Zpd2tNR1ZlR3FadG0zNjlsR2dDUVFYdlhMeitXRlF3d0xQNFI4T3MxWEJx?=
 =?utf-8?B?TFFUSEwyV3dtd3pIYW9wWWRieGlRWHdEeUVpQ0FlWTZvdWdIdmJKaGhmRGk0?=
 =?utf-8?B?UkZJL1RMSm9mWFhHTEZsN0hMcTZZMjFFQ0ltNnNscWVlZExiWlk3OGduZEFO?=
 =?utf-8?Q?uo57uYm57L8/CoYWv87rroY+6rwbpaTWwGZtDgG90SrN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79d72bb2-493e-47fe-0611-08dbf281e8e8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 15:26:37.6874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /xG8v0cvxRfLGrMcVd0quKeS6U+sS22PCYy3BXGh+ssi8VIjW18Hfd720wFXa1rmk/bK2ro+MAP2Tk5aKOAHOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5377

On 12/01, Eugenio Perez Martin wrote:
> On Fri, Dec 1, 2023 at 11:49 AM Dragos Tatulea <dtatulea@nvidia.com> wrote:
> >
> > Add a bitmask variable that tracks hw vq field changes that
> > are supposed to be modified on next hw vq change command.
> >
> > This will be useful to set multiple vq fields when resuming the vq.
> >
> > The state needs to remain as a parameter as it doesn't make sense to
> > make it part of the vq struct: fw_state is updated only after a
> > successful command.
> >
> 
> I don't get this paragraph, "modified_fields" is a member of
> "mlx5_vdpa_virtqueue". Am I missing something?
> 
I think this paragraph adds more confusion than clarification. I meant
to say that the state argument from modified_virtqueue needs to remain
there, as opposed to integrating it into the mlx5_vdpa_virtqueue struct.

> 
> > Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> > ---
> >  drivers/vdpa/mlx5/net/mlx5_vnet.c | 48 +++++++++++++++++++++++++------
> >  1 file changed, 40 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > index 12ac3397f39b..d06285e46fe2 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -120,6 +120,9 @@ struct mlx5_vdpa_virtqueue {
> >         u16 avail_idx;
> >         u16 used_idx;
> >         int fw_state;
> > +
> > +       u64 modified_fields;
> > +
> >         struct msi_map map;
> >
> >         /* keep last in the struct */
> > @@ -1181,7 +1184,19 @@ static bool is_valid_state_change(int oldstate, int newstate)
> >         }
> >  }
> >
> > -static int modify_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq, int state)
> > +static bool modifiable_virtqueue_fields(struct mlx5_vdpa_virtqueue *mvq)
> > +{
> > +       /* Only state is always modifiable */
> > +       if (mvq->modified_fields & ~MLX5_VIRTQ_MODIFY_MASK_STATE)
> > +               return mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_STATE_INIT ||
> > +                      mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND;
> > +
> > +       return true;
> > +}
> > +
> > +static int modify_virtqueue(struct mlx5_vdpa_net *ndev,
> > +                           struct mlx5_vdpa_virtqueue *mvq,
> > +                           int state)
> >  {
> >         int inlen = MLX5_ST_SZ_BYTES(modify_virtio_net_q_in);
> >         u32 out[MLX5_ST_SZ_DW(modify_virtio_net_q_out)] = {};
> > @@ -1193,6 +1208,9 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
> >         if (mvq->fw_state == MLX5_VIRTIO_NET_Q_OBJECT_NONE)
> >                 return 0;
> >
> > +       if (!modifiable_virtqueue_fields(mvq))
> > +               return -EINVAL;
> > +
> 
> I'm ok with this change, but since modified_fields is (or will be) a
> bitmap tracking changes to state, addresses, mkey, etc, doesn't have
> more sense to check it like:
> 
> if (modified_fields & 1<<change_1_flag)
>   // perform change 1
> if (modified_fields & 1<<change_2_flag)
>   // perform change 2
> if (modified_fields & 1<<change_3_flag)
>   // perform change 13
> ---
> 
> Instead of:
> if (!modified_fields)
>   return
> 
> if (modified_fields & 1<<change_1_flag)
>   // perform change 1
> if (modified_fields & 1<<change_2_flag)
>   // perform change 2
> 
> // perform change 3, no checking, as it is the only possible value of
> modified_fields
> ---
> 
> Or am I missing something?
> 
modifiable_virtqueue_fields() is meant to check that the modification is
done only in the INIT or SUSPEND state of the queue. Or did I
misunderstand your question?

> The rest looks good to me.
>
Thanks for reviewing my patches Eugenio!

> >         if (!is_valid_state_change(mvq->fw_state, state))
> >                 return -EINVAL;
> >
> > @@ -1208,17 +1226,28 @@ static int modify_virtqueue(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtque
> >         MLX5_SET(general_obj_in_cmd_hdr, cmd_hdr, uid, ndev->mvdev.res.uid);
> >
> >         obj_context = MLX5_ADDR_OF(modify_virtio_net_q_in, in, obj_context);
> > -       MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select,
> > -                  MLX5_VIRTQ_MODIFY_MASK_STATE);
> > -       MLX5_SET(virtio_net_q_object, obj_context, state, state);
> > +       if (mvq->modified_fields & MLX5_VIRTQ_MODIFY_MASK_STATE)
> > +               MLX5_SET(virtio_net_q_object, obj_context, state, state);
> > +
> > +       MLX5_SET64(virtio_net_q_object, obj_context, modify_field_select, mvq->modified_fields);
> >         err = mlx5_cmd_exec(ndev->mvdev.mdev, in, inlen, out, sizeof(out));
> >         kfree(in);
> >         if (!err)
> >                 mvq->fw_state = state;
> >
> > +       mvq->modified_fields = 0;
> > +
> >         return err;
> >  }
> >
> > +static int modify_virtqueue_state(struct mlx5_vdpa_net *ndev,
> > +                                 struct mlx5_vdpa_virtqueue *mvq,
> > +                                 unsigned int state)
> > +{
> > +       mvq->modified_fields |= MLX5_VIRTQ_MODIFY_MASK_STATE;
> > +       return modify_virtqueue(ndev, mvq, state);
> > +}
> > +
> >  static int counter_set_alloc(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
> >  {
> >         u32 in[MLX5_ST_SZ_DW(create_virtio_q_counters_in)] = {};
> > @@ -1347,7 +1376,7 @@ static int setup_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *mvq)
> >                 goto err_vq;
> >
> >         if (mvq->ready) {
> > -               err = modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
> > +               err = modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
> >                 if (err) {
> >                         mlx5_vdpa_warn(&ndev->mvdev, "failed to modify to ready vq idx %d(%d)\n",
> >                                        idx, err);
> > @@ -1382,7 +1411,7 @@ static void suspend_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *m
> >         if (mvq->fw_state != MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY)
> >                 return;
> >
> > -       if (modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
> > +       if (modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_SUSPEND))
> >                 mlx5_vdpa_warn(&ndev->mvdev, "modify to suspend failed\n");
> >
> >         if (query_virtqueue(ndev, mvq, &attr)) {
> > @@ -1407,6 +1436,7 @@ static void teardown_vq(struct mlx5_vdpa_net *ndev, struct mlx5_vdpa_virtqueue *
> >                 return;
> >
> >         suspend_vq(ndev, mvq);
> > +       mvq->modified_fields = 0;
> >         destroy_virtqueue(ndev, mvq);
> >         dealloc_vector(ndev, mvq);
> >         counter_set_dealloc(ndev, mvq);
> > @@ -2207,7 +2237,7 @@ static void mlx5_vdpa_set_vq_ready(struct vdpa_device *vdev, u16 idx, bool ready
> >         if (!ready) {
> >                 suspend_vq(ndev, mvq);
> >         } else {
> > -               err = modify_virtqueue(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
> > +               err = modify_virtqueue_state(ndev, mvq, MLX5_VIRTIO_NET_Q_OBJECT_STATE_RDY);
> >                 if (err) {
> >                         mlx5_vdpa_warn(mvdev, "modify VQ %d to ready failed (%d)\n", idx, err);
> >                         ready = false;
> > @@ -2804,8 +2834,10 @@ static void clear_vqs_ready(struct mlx5_vdpa_net *ndev)
> >  {
> >         int i;
> >
> > -       for (i = 0; i < ndev->mvdev.max_vqs; i++)
> > +       for (i = 0; i < ndev->mvdev.max_vqs; i++) {
> >                 ndev->vqs[i].ready = false;
> > +               ndev->vqs[i].modified_fields = 0;
> > +       }
> >
> >         ndev->mvdev.cvq.ready = false;
> >  }
> > --
> > 2.42.0
> >
> 

