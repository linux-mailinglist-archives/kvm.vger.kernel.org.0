Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2D8562393
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 21:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbiF3Twm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 15:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiF3Twk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 15:52:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27DDF443E9
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656618759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y6xqv8hs+XRgwjFSDNBYvhusbDhaYngjQ59D9YVxo8g=;
        b=bA2kSgjHSPTsc5ub1XnKsushvrd6jkycReQ9+rKpI+Ge65Bv3ADrlNjfLm2hlBDihQ5f0d
        +pKQoGq47aO1ELdO01wVG/vU3FL2K7JUxkkUbWfM+8MDP78VI4zyc+1DFnA7QC0kq8VE+j
        pIzNODGzdjNTAiRfKjMoCoOmZLlvLWo=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-DMjd-nX7NO2MO7Rq-9XQRQ-1; Thu, 30 Jun 2022 15:52:37 -0400
X-MC-Unique: DMjd-nX7NO2MO7Rq-9XQRQ-1
Received: by mail-il1-f200.google.com with SMTP id w15-20020a056e021a6f00b002d8eef284f0so49768ilv.6
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 12:52:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Y6xqv8hs+XRgwjFSDNBYvhusbDhaYngjQ59D9YVxo8g=;
        b=1Vttjd2K5fAdf4VQ+6JHNzvJPhrtuf6sO+jjYG93nMDIL75AF1KK7eMBrAJ5R2uAqz
         ltxvJ9+ja693zOQxcJ29zmGlhS/QWVYxbFOcm6J19T4YsKQDWeAXqG/bavuoVmozt78f
         dyQhzCbhuESrjtu2U3GjgPh1IyMpJ8mEgfNnEAqDBlVJwYwjl1qy425QY01C5BZ7ODFe
         NFZS64qzRWQm7KFd31Ai6D4yWzI1aTEm5UVWAgYmAiGkL+Vt5lfHkMZqh33W7uwGj0R6
         HprmozivOEk4KncUR1gp5m4VhxQlSUeGnDijRF0gJNt1fmgPHCYIJ4+u09mZNL6XjcHP
         cS/g==
X-Gm-Message-State: AJIora8i4bP4njoZCYzU5P+hhnMivLT9Gz/IbrSBpOXW3vUkKkE6M8Xl
        X0vuCOkTt4WjbfKLbARtaKwVS176YjKNqvWr9jWLDzTHQetYlo68XEXztxiP6Xz6N61TT/xt9uT
        XSqNdzKg7EGa2
X-Received: by 2002:a05:6e02:1a68:b0:2da:9b52:28c5 with SMTP id w8-20020a056e021a6800b002da9b5228c5mr5618980ilv.253.1656618756968;
        Thu, 30 Jun 2022 12:52:36 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vVE2mrAWAgc5A5eRbm90N2mWbOhnx1f03iIjBRSRBRlLiVaiEN67U+EQ/COzeFWjD9VC1efQ==
X-Received: by 2002:a05:6e02:1a68:b0:2da:9b52:28c5 with SMTP id w8-20020a056e021a6800b002da9b5228c5mr5618968ilv.253.1656618756764;
        Thu, 30 Jun 2022 12:52:36 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x42-20020a0294ad000000b00330c5581c03sm8880286jah.1.2022.06.30.12.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 12:52:36 -0700 (PDT)
Date:   Thu, 30 Jun 2022 13:51:40 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Schspa Shi <schspa@gmail.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] vfio: Clear the caps->buf to NULL after free
Message-ID: <20220630135140.2dd079c9.alex.williamson@redhat.com>
In-Reply-To: <20220629022948.55608-1-schspa@gmail.com>
References: <20220629022948.55608-1-schspa@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 29 Jun 2022 10:29:48 +0800
Schspa Shi <schspa@gmail.com> wrote:

> On buffer resize failure, vfio_info_cap_add() will free the buffer,
> report zero for the size, and return -ENOMEM.  As additional
> hardening, also clear the buffer pointer to prevent any chance of a
> double free.
> 
> Signed-off-by: Schspa Shi <schspa@gmail.com>
> 

Applied to vfio next branch for v5.20.  Thanks,

Alex

