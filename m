Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F727D97A0
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 14:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345650AbjJ0MR4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 08:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjJ0MRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 08:17:55 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFB8C0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 05:17:53 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40850b244beso15676595e9.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 05:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698409071; x=1699013871; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HnSSviJMbW73CYFlxlkiiUfIJKhXBNtv3pZYT4H9PPE=;
        b=co579VLKrA/JlhVxKXF5+hGXDgFVBxmXYAzgiJ5jBXxBPKOJtLDSjg8djtCBdxrKUb
         DSFZb+dKSZYCZZnRTqufoVBQa8V+4xZ8kS3BfpKNnpebUKl7p4nV2suCTaLlunvJARDk
         73im62tM3BHSZFIEvadj35PMZYgzNOWOHE8VBH1nFcTXGUQamri65FRMga0wxpkjE1Dv
         9a1COrLCABMLurxhonr/k6OpL6l/vp0QYYAmlyqNu0wOTB/v44tpp6iTVsA94IR0aLPb
         wwpXMB/47RptYSxE5/WgAh/b9x58H+WyXIdgf5RCZrTv30ruPvvt0blydCMAc7rG95WX
         J5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698409071; x=1699013871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnSSviJMbW73CYFlxlkiiUfIJKhXBNtv3pZYT4H9PPE=;
        b=Rsl6i7DwNyFLkBfs6XrDMlnWKE3/TZA/PQdgEWQMtLLuoJsLJrP69cu/pikgEWVci8
         xtDcD6JtiKaqVJPIAByPjTeICtUNOFuawEJ4sKTNb8m+oSRrFkba3GZbDjS6nQGdqWJz
         lVw4SzjQaTdXzL3ZnRcSgC+4xpHJeUIQsMSctwdKBSyLX2TxSIblMTKWNWnXp8Slg5Q5
         BW+4C30gatPA5At2pEZpTXgbWhYf+FGLc9loXXH15EJzqez3uD+hrTGJtWqmYBVZkAUY
         YhYGjKcePVPAPt5dfINb/YcY7Cvt3UvWepzAbcq1ZdZdOSbcskh4CCvhgUTNOGYIeCTm
         8hYA==
X-Gm-Message-State: AOJu0YwUSUfOe2yuXQ1/e2v1o0lcyeQMSheCjLUeEabrd2kLgKlUhbYj
        6kwMyiUXmq2oYxwz23g6c0t4XA==
X-Google-Smtp-Source: AGHT+IHC6uUGgPeWGP9gaB+YAHmpUGN6zGIl085NvPG+QmhGh3Kqwvs35IBgNlyG8cGXTzKE3kaLCg==
X-Received: by 2002:a05:600c:5251:b0:407:8e68:4a5b with SMTP id fc17-20020a05600c525100b004078e684a5bmr2473427wmb.38.1698409071274;
        Fri, 27 Oct 2023 05:17:51 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id l41-20020a05600c1d2900b004090ca6d785sm1554896wms.2.2023.10.27.05.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 05:17:51 -0700 (PDT)
Date:   Fri, 27 Oct 2023 15:17:48 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Bo Liu <liubo03@inspur.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-XXX] vhost-vdpa: fix use after free in
 vhost_vdpa_probe()
Message-ID: <1eaf041b-6556-40e3-ad80-993754b2bc0f@kadam.mountain>
References: <cf53cb61-0699-4e36-a980-94fd4268ff00@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf53cb61-0699-4e36-a980-94fd4268ff00@moroto.mountain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ugh...  Crap.

I modified this patch to apply cleanly on net but I still didn't change
the subject to net.  But now that I'm looking at it actually goes
through one of the virt trees.

It should still apply to whatever virt tree as well.  It's just shifted
70 lines.

regards,
dan carpenter

