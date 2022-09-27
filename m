Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E785EB949
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 06:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiI0Ein (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 00:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiI0Eim (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 00:38:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28491FB302
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664253520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LZzmX/LZpNg3sCgzTfVweFFRT/JxjvUTK3cLB50DJXY=;
        b=KnkDNNYqKwLTF61b1lrwoPHaAypMreK6KuIbfEPRCcCqaJX1zwvlnN+F0eND4URNak+92Q
        vazNWa05OnB60IXYlhO9hD4R68wQj7fH9OB2B/wnePDaDIGtVQefm3BfWJjlJaf2P6rQGb
        A7MRukClZnT62OYo3V+80yo/x/0uDFw=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-rHs3x6s6PWeh2zqeoSKyVg-1; Tue, 27 Sep 2022 00:38:38 -0400
X-MC-Unique: rHs3x6s6PWeh2zqeoSKyVg-1
Received: by mail-ot1-f70.google.com with SMTP id p4-20020a9d4544000000b0065952fed1aeso4189666oti.6
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 21:38:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=LZzmX/LZpNg3sCgzTfVweFFRT/JxjvUTK3cLB50DJXY=;
        b=cjhVturEX4/qzdv6johCpoDFNxbOEFVWEjA0uIC/DXAGVD8CT2cYOv0CvXORgfzXVt
         8qc/UmYiVemaKADqb0oa6XBw24bYuWmEidFx5SJ711emC1SKMMl+fyuJOZtAW0nbWQvK
         D2YQE6jgVFCHZul3xscVrFAblleKVVJUZ3+h0omjQMA4AmsiKHK1i/Njh0woaUlo67tM
         SqHtpwOdthl+U8NQQNhPqqDXVv3iac4zcYMTiehS2tR4RxfDaFh0wkrtE0u6VbAF/na1
         rSBpUvX14LBcVU4ZarKRbETAmvrSkFj8qRBpOP5ROJDB8GIEvY37Iywozblfb7cBpURP
         d8BQ==
X-Gm-Message-State: ACrzQf2ZqMMBXu8Qx9u6QouxdJLFHQSd7T6w6e99246L7hMjR+i5ldlJ
        BMLEjrhHRA6oGrWvm/VRajRGlwHUyv/UYY09WJvXfIhcJvjMq4bf4rdk2jv5pcz411C2Kf1LIMf
        tGAf7RCvCzP8sO9cFWzWwc5jit5oU
X-Received: by 2002:a05:6870:e409:b0:127:d330:c941 with SMTP id n9-20020a056870e40900b00127d330c941mr1098029oag.280.1664253517664;
        Mon, 26 Sep 2022 21:38:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6KWLqfJGIYu2DMf98dx7P5bJF0eOmO5aC9XWtZcg5CfjpovBHj6fifEe189yrHy4f3HtwIm3fQ26DaUdD8y+0=
X-Received: by 2002:a05:6870:e409:b0:127:d330:c941 with SMTP id
 n9-20020a056870e40900b00127d330c941mr1098021oag.280.1664253517451; Mon, 26
 Sep 2022 21:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220927030117.5635-1-lingshan.zhu@intel.com> <20220927030117.5635-5-lingshan.zhu@intel.com>
In-Reply-To: <20220927030117.5635-5-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 27 Sep 2022 12:38:26 +0800
Message-ID: <CACGkMEuzee5cuEhkPVduvesFEo7FfXWOmxHf70bN4JWp7Zi0GQ@mail.gmail.com>
Subject: Re: [PATCH V2 RESEND 4/6] vDPA: check virtio device features to
 detect MQ
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 11:09 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> vdpa_dev_net_mq_config_fill() should checks device features
> for MQ than driver features.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>

Acked-by: Jason Wang <jasowang@redhat.com>

> ---
>  drivers/vdpa/vdpa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index 829fd4cfc038..84a0c3877d7c 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -839,7 +839,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>                               VDPA_ATTR_PAD))
>                 return -EMSGSIZE;
>
> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
> +       return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
>  }
>
>  static int
> --
> 2.31.1
>

