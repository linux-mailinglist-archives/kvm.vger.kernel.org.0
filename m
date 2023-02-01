Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB89686B12
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 17:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbjBAQEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 11:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232720AbjBAQEU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 11:04:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA7142DFE
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 08:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675267415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b1H9S6BHMI3ZJyJH5QgphGWijBn41dRJFzhUalzPkqw=;
        b=f27xwRz/3I/uAvKds6zrLClWDYmXAzyZFD11ka1qC6wbI5JTp5oXAVs7iyMYirZA5wEEhS
        pNpqtzcyRLCamP0QsFBvsoS/nZzQtjDP61UGXlVgGZPrboQjqN583UCEUM/PQh02CK5kHQ
        FUBh2BWGnfQc3u7v+3PT2olntl4UBEc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542-oHM144jyOryNsRCqadcYbA-1; Wed, 01 Feb 2023 11:03:34 -0500
X-MC-Unique: oHM144jyOryNsRCqadcYbA-1
Received: by mail-wr1-f70.google.com with SMTP id t20-20020adfba54000000b002be0eb97f4fso3019158wrg.8
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 08:03:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1H9S6BHMI3ZJyJH5QgphGWijBn41dRJFzhUalzPkqw=;
        b=dnYfqTHWFf+zc6mI//tSVqT8w0nToYTSy4piMzCuFHKqEJIHGwe9kw3ldyD+hBoGbh
         Itx+srZMB5ISRx9jhmr61O1qzAVKvpgt0wDGGyuMbyC0oMMD2POnbCXPb/s0A2FS+Uoc
         Do8TPloJGgTafY/L7FXoI5uzyQ0XCYn3kpBf7ZKuNmWbDWERoGkSNPCremoQQU5WHrF5
         NmcgIdfTij0sdm+hxQ76S61s8crUkl6g8khvOKihMVzOjTyBhRMgs7OXiweRTMd4SYoj
         QEzkjVZm/htmv3SIR8kcFV0M3c7AejrwBpnu8HU29PpEx3Cuzry14z2U2cL+x5+aOpPk
         aHdg==
X-Gm-Message-State: AO0yUKV6P+kdjuIMyt5GJZtFaLav9KsRa9vnO5TZqZ4W5IqoBIL6/cRe
        1wzXCAaUY+lsZoJsleN1Z0k2ow4Ib19uNvz8SgIl6o42ll3WWQd43XzAvoUpTPQVIpClsoBYLZT
        ZbSj3Q+dZ1C5t
X-Received: by 2002:a05:6000:80e:b0:2bf:e61c:9b4 with SMTP id bt14-20020a056000080e00b002bfe61c09b4mr3116850wrb.4.1675267413052;
        Wed, 01 Feb 2023 08:03:33 -0800 (PST)
X-Google-Smtp-Source: AK7set9mkTqfA7HywIzLWLc57g9ZcuE/3dWDYMdAt3c3LDfa20GdCpoBqXPbTzeqKwveMvOdDdv25g==
X-Received: by 2002:a05:6000:80e:b0:2bf:e61c:9b4 with SMTP id bt14-20020a056000080e00b002bfe61c09b4mr3116833wrb.4.1675267412882;
        Wed, 01 Feb 2023 08:03:32 -0800 (PST)
Received: from redhat.com ([2.52.144.173])
        by smtp.gmail.com with ESMTPSA id a18-20020adffad2000000b002be53aa2260sm18737017wrs.117.2023.02.01.08.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 08:03:32 -0800 (PST)
Date:   Wed, 1 Feb 2023 11:03:28 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Eugenio Perez Martin <eperezma@redhat.com>
Subject: Re: [PATCH] vhost-vdpa: print error when vhost_vdpa_alloc_domain
 fails
Message-ID: <20230201110253-mutt-send-email-mst@kernel.org>
References: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
 <20230201105200-mutt-send-email-mst@kernel.org>
 <CAJs=3_Bw5QiZRu-nSeprhT1AMyGqw4oggTY=t+yaPeXBOAOjLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJs=3_Bw5QiZRu-nSeprhT1AMyGqw4oggTY=t+yaPeXBOAOjLQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 01, 2023 at 05:54:53PM +0200, Alvaro Karsz wrote:
> > I'm not sure this is a good idea. Userspace is not supposed to be
> > able to trigger dev_err.
> 
> dev_warn then?

dev_warn_once is ok.

-- 
MST

