Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8566DCFFD
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 05:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjDKDKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 23:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjDKDKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 23:10:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4C0198A
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 20:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681182599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PIRYPPRzMr0WDaISNXv8JTRc994C6mm8nrgRnA2e2II=;
        b=ezyh0MZVZVz8tkd24/Ot38I+NvnozRXeKUAK4K++RXCbCptS/equYgEJKy1h0Sj7SeBvSo
        VJ/1bvPNKvNxe6KT0PIOPBR3df20TIw2EKV4xgyhwmXOyQanS6PnlBM102a+6An48i1N++
        H9bb1ISMmv8HNaEr2sw2CHjcOnpRc3Y=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-ryydoUkJMV2_yFXvMnggrg-1; Mon, 10 Apr 2023 23:09:58 -0400
X-MC-Unique: ryydoUkJMV2_yFXvMnggrg-1
Received: by mail-oo1-f72.google.com with SMTP id y11-20020a4ad64b000000b0053e9b6b7ebfso9243942oos.11
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 20:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681182597; x=1683774597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PIRYPPRzMr0WDaISNXv8JTRc994C6mm8nrgRnA2e2II=;
        b=kN3Q4hIRwvUH1Gv4m+RBnfg52hscVbGRt3XlAlNIDLJMTPUQUT2XUJsr8D2f8n7dqN
         iPo4ZXTOw7U/LRo4IYNbcyz9ISMUKomxNDgORm66iYlOwkl6RQYgV+2RK1HC9ZRHM5xr
         6fHtRdCHWim8l9PwbpvO4fDVfe6cwzJ96V/Eca4XrEZoIHmAWW3/Rec4u/DZQFReEmND
         07y2CqLG6FzDio00noSUlbNHwnVVUwuaWlxI98VVx+goR0upnEMHEQzH/brTjyk65r5Z
         6QuZI2/61FxiwidSbpC8KQVo23vZs2WW3aKUoKUmlgakge/Sc1qExs5MdkGRr0Li3Z+P
         EQzA==
X-Gm-Message-State: AAQBX9cK6f+a4+KifzY3xStVPVl92VoWl30NyANZLceEPTeeBeHi3xtd
        3TeXBXbgspCPBNT0P8qR+IJ0Rx/mpab7KVD76GIvypCLp6dL4oA8AV4H9G5f2CVluK4MWpWq4jT
        86w5hQIRHBBfKd5k8CQCCzn2YWsG4
X-Received: by 2002:a54:4108:0:b0:389:86c3:b1fb with SMTP id l8-20020a544108000000b0038986c3b1fbmr1767290oic.9.1681182597579;
        Mon, 10 Apr 2023 20:09:57 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZeucJf+EbWtNuhPzUoVMqvWrsCF6D+3DIu6eOe4RcryYcADiNhudEFaSmmkr0WQmH0aZjfEc0FYx82LleldDo=
X-Received: by 2002:a54:4108:0:b0:389:86c3:b1fb with SMTP id
 l8-20020a544108000000b0038986c3b1fbmr1767284oic.9.1681182597366; Mon, 10 Apr
 2023 20:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <20230410150130.837691-1-lulu@redhat.com>
In-Reply-To: <20230410150130.837691-1-lulu@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 11 Apr 2023 11:09:46 +0800
Message-ID: <CACGkMEvTdgvqacFmMJZD4u++YJwESgSmLF6CMdAJBBqkxpZKgg@mail.gmail.com>
Subject: Re: [PATCH] vhost_vdpa: fix unmap process in no-batch mode
To:     Cindy Lu <lulu@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10, 2023 at 11:01=E2=80=AFPM Cindy Lu <lulu@redhat.com> wrote:
>
> While using the no-batch mode, the process will not begin with
> VHOST_IOTLB_BATCH_BEGIN, so we need to add the
> VHOST_IOTLB_INVALIDATE to get vhost_vdpa_as, the process is the
> same as VHOST_IOTLB_UPDATE
>
> Signed-off-by: Cindy Lu <lulu@redhat.com>
> ---
>  drivers/vhost/vdpa.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 7be9d9d8f01c..32636a02a0ab 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1074,6 +1074,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhos=
t_dev *dev, u32 asid,
>                 goto unlock;
>
>         if (msg->type =3D=3D VHOST_IOTLB_UPDATE ||
> +           msg->type =3D=3D VHOST_IOTLB_INVALIDATE ||

I'm not sure I get here, invalidation doesn't need to create a new AS.

Or maybe you can post the userspace code that can trigger this issue?

Thanks

>             msg->type =3D=3D VHOST_IOTLB_BATCH_BEGIN) {
>                 as =3D vhost_vdpa_find_alloc_as(v, asid);
>                 if (!as) {
> --
> 2.34.3
>

