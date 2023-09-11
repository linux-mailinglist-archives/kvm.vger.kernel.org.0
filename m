Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E92DB79B9A6
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 02:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbjIKUsV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 16:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239599AbjIKOYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 10:24:20 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46849CF0
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 07:24:15 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-991c786369cso598879466b.1
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 07:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694442253; x=1695047053; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=77wmyEqNTeDGUTOmfGVt3GM6ImVu59aR1ZuCl07cYtc=;
        b=X6pTQDR2DZBZ/WzdandnIT2QQcc+5eddz1nCgLRDSeMyEDihG9ynBbesczURf7uOHi
         aCE9THHpHtmQE2pYCU8S2rB6eMjWCq+ZUxviZHtzByUQGooAMdlEHFPKltZxbehwVpCa
         rXN/RNQuoh8SSQqpsc98T/h8sfTPyPBRvU9PyFwW2pJmvp7KkniVoxW5+qnDT8XI2w23
         AApcGz3w0gvSPy5JmUv/Z4nw6DlnML5BKwqEjqHWE1/AX7i22v0K6TyAlZ0CdnspHQGE
         T9BTI7Tl2EEJMsTVOWqQadK5AIMudstjLvhvX76E1cloobObuv8GmEPW7Uibc+b7gR2z
         jkSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694442253; x=1695047053;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=77wmyEqNTeDGUTOmfGVt3GM6ImVu59aR1ZuCl07cYtc=;
        b=oFU6o27JPr8dxfuO9rIfUvus2oifLSkzuDwbF5J5zNihq9M3QopijpZ6wqUq4moPsv
         0MdskPnnf+HzuruCZYSo7euhSiZpmiamFaB48KoJqmkoBdat4g9Y/y4gYjpTihY0GC2M
         rZv+yq8XJiq0Eo1h+iWqGaz9xV+wv9FsOymXXM4ZYfqLXZeO2dwNoKG5BMqNBxC/6fjx
         P1FpQ4El+UtCdQ9RTx/NJxt/tQYx0M64b++bM/aE7UNLW/dTBcKWCvoeNFstVOfovLLW
         zU669LKFsOHOxnKOtuDkOd/FT9pr/Mf7pSA8snddNiPeNI6MQoUnoT91WNMmXUCrbi3t
         WLSg==
X-Gm-Message-State: AOJu0Yw41+yO2IfNOKP0i0jE5/AO4VFhVc5fDr8N5lEgAPIEvS51GtUV
        0h8Ea2z0q5ADNmlbqpXAMRLAHw==
X-Google-Smtp-Source: AGHT+IFwixzQiIoWbOPCD8vfySFcjlXiXCkI/jtnoIPnq/qrqyThN++agwziFT7GEG0gJrAhK+agng==
X-Received: by 2002:a17:906:5a70:b0:9a1:c370:1aef with SMTP id my48-20020a1709065a7000b009a1c3701aefmr8580666ejc.55.1694442253697;
        Mon, 11 Sep 2023 07:24:13 -0700 (PDT)
Received: from localhost (h3220.n1.ips.mtn.co.ug. [41.210.178.32])
        by smtp.gmail.com with ESMTPSA id kj27-20020a170907765b00b009a5f7fb51dcsm5415145ejc.42.2023.09.11.07.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 07:24:13 -0700 (PDT)
Date:   Mon, 11 Sep 2023 17:24:09 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     brett.creeley@amd.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] vfio/pds: Add VFIO live migration support
Message-ID: <1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Brett Creeley,

The patch bb500dbe2ac6: "vfio/pds: Add VFIO live migration support"
from Aug 7, 2023 (linux-next), leads to the following Smatch static
checker warning:

	drivers/vfio/pci/pds/lm.c:117 pds_vfio_put_save_file()
	warn: sleeping in atomic context

The call tree is:

pds_vfio_state_mutex_unlock() <- disables preempt
-> pds_vfio_put_save_file() <- sleeps

drivers/vfio/pci/pds/vfio_dev.c
    29  void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
    30  {
    31  again:
    32          spin_lock(&pds_vfio->reset_lock);
                ^^^^^^^^^
Preempt disabled

    33          if (pds_vfio->deferred_reset) {
    34                  pds_vfio->deferred_reset = false;
    35                  if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
    36                          pds_vfio_put_restore_file(pds_vfio);
    37                          pds_vfio_put_save_file(pds_vfio);
                                ^^^^^^^^^^^^^^^^^^^^^^

    38                          pds_vfio_dirty_disable(pds_vfio, false);
    39                  }
    40                  pds_vfio->state = pds_vfio->deferred_reset_state;
    41                  pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
    42                  spin_unlock(&pds_vfio->reset_lock);
    43                  goto again;
    44          }
    45          mutex_unlock(&pds_vfio->state_mutex);
    46          spin_unlock(&pds_vfio->reset_lock);

Unrelated but it really makes me itch that we drop the mutex before the
spinlock.

    47  }

drivers/vfio/pci/pds/lm.c
    112 void pds_vfio_put_save_file(struct pds_vfio_pci_device *pds_vfio)
    113 {
    114         if (!pds_vfio->save_file)
    115                 return;
    116 
--> 117         pds_vfio_put_lm_file(pds_vfio->save_file);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Calls mutex_lock().

    118         pds_vfio->save_file = NULL;
    119 }

regards,
dan carpenter
