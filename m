Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B849270E3AE
	for <lists+kvm@lfdr.de>; Tue, 23 May 2023 19:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238202AbjEWRaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 May 2023 13:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238346AbjEWRaJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 May 2023 13:30:09 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544EC186
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 10:29:56 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64d3491609fso12612b3a.3
        for <kvm@vger.kernel.org>; Tue, 23 May 2023 10:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684862996; x=1687454996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nhOVpdiqhCvs7GVV7f2dklwaVtM++uCHQCldPOpHCUk=;
        b=A24777sFuS5neXn2X580FSjNLT8hS3n/fA59VHL1HgoGN4qo+vI1L2wT8WPOK1StqC
         PcNMIz3+z2+2SnzxaOWHjZJNhIlO9GvPIxzUt2GsSAGSw2nIMjGbzqLCnn0lNvkM+zDe
         J17yTm15T4qXNbdDlwznS7hOhy4dWvxpnay5A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684862996; x=1687454996;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nhOVpdiqhCvs7GVV7f2dklwaVtM++uCHQCldPOpHCUk=;
        b=iFNHhyEVs6W4qxIkZOc4hLwGXGMlYaH9lzpGsIVu/fv+GbHcLTsH8nOIwUTiYv3TcT
         nIA3esscW82ufa1EuKukeo50cDiE6wXhApDv53WGDMTgEdApc8J5LjRJvLLhouzgmm0U
         Ug7tnaw5lSkCMYCgtBSoZUUYUy9puzwE73lEYTfhjEt6QTqslZkE6l9ODCr7kdxLqDsM
         zEinirH9nbTEd3mI0fvMIDeqIzohxgUh27qWSmOnTcnP+T7tdkeK/HrmubdJJjsngHkT
         8c4YgIgWTW+x9+pr8aQ/AFU6n+Zq7AtJ92CoVScw7uP95uI1nuFVgXCUk/Exqf+xbMLl
         PM+g==
X-Gm-Message-State: AC+VfDxSsvdjC0Z4DpsoHoSfbwQG6xhYdoKVgMVFhfWs4Up1VPOv5akH
        Q2Izi3BJHLbh1Y3aNmbCFkBksw==
X-Google-Smtp-Source: ACHHUZ4uuIdgumk1jumRCzlG+a3yry5AfnyGcbp0y8NXoHGyEspOACJ+nTy3VqiD9jcpG3NGGfSDSQ==
X-Received: by 2002:a05:6a20:5482:b0:10b:71c:20c5 with SMTP id i2-20020a056a20548200b0010b071c20c5mr11647062pzk.51.1684862995725;
        Tue, 23 May 2023 10:29:55 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id bs5-20020a632805000000b0051eff0a70d7sm6210358pgb.94.2023.05.23.10.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 10:29:55 -0700 (PDT)
Date:   Tue, 23 May 2023 10:29:54 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2][next] vfio/ccw: Replace one-element array with
 flexible-array member
Message-ID: <202305231029.FC995C740F@keescook>
References: <cover.1684805398.git.gustavoars@kernel.org>
 <3c10549ebe1564eade68a2515bde233527376971.1684805398.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c10549ebe1564eade68a2515bde233527376971.1684805398.git.gustavoars@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 22, 2023 at 07:35:12PM -0600, Gustavo A. R. Silva wrote:
> One-element arrays are deprecated, and we are replacing them with flexible
> array members instead. So, replace one-element array with flexible-array
> member in struct vfio_ccw_parent and refactor the the rest of the code
> accordingly.
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/297
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
