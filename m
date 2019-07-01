Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2777F2FAE9
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 13:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfE3L2Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 07:28:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33353 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfE3L2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 07:28:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so5819526wmh.0;
        Thu, 30 May 2019 04:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hnYCxGJZKcT1U2WS36X5u87tJhTuR53JcMerladDNc0=;
        b=i5X2x8yvViOlOAIO56aMVL1XacEOp7aNYpqcl9r2QVBBhlZSsYcMYD0d+M8eOKDW6L
         HibcDgAMiPhRGwT7oZvc+6mhnR4hubClpgh8jpD7sS8o4dDFbWpdUo7VfEpb+ZD9Awl6
         AfxXSAk7B7/zbML24+6rN4BDX80e6yfglSzfNhHq05+O4OIfQR8sxZvr4EK6YjcNq1PT
         5f5qUKbZ6fZWy2k+ouU62OC/DfYJLDUSlCvN1I6qeoXl3z4TrQzk701I4riYhyT2pQLc
         WyZo6kpqP2dJikq2M1fvhXqJZN7fIHdchVJJtyoEoOylP9183TJgOp2GXfnT6p7x1+U/
         SH4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=hnYCxGJZKcT1U2WS36X5u87tJhTuR53JcMerladDNc0=;
        b=djDp1x/zJ/aLIbjUIbqRkqX/DM68wsuKsQXjy01PH6D6sNJAmy/Trynb0VynI4QqRZ
         R/QMWmVgHJlO6U/8BZij86XuzlXLtxbSMSszFnrwaTooxxqbqWaNFc2FHUAlTkaPWDwQ
         YYrCD0189Ir2nVjZ9F8kRsIwd+csEOx51smeR556wlf6E9wB3TiiP2miaJAfGZ8vlfQi
         qpxiUHi9wDS87qN/UmlAjrMpHkTKXFDxZIJjsmti22aB3X1uLE23lgQSIuFzGEKdef1r
         CM4H+Z7lyWNWA/Y06jXybrUDT4iHzhDXRnoaZI/aVuHRxPLnLjzwcTq+eo9FKGrufhMs
         RPXg==
X-Gm-Message-State: APjAAAX5czVxs5Efs7ccOLoVEfSJrq3bhyFPknMRnpl7bGPJw+wBW1aG
        d4CLTnZePBZu5YeJGgo0MmNzR3YR
X-Google-Smtp-Source: APXvYqyaf2R6Ej4BRd88YAgggJyetRd3ANiOej1ufNx8g2/vFwVDnYzinYwJwDoMXrm4Osy0n1TvKw==
X-Received: by 2002:a1c:1947:: with SMTP id 68mr1952400wmz.171.1559215693274;
        Thu, 30 May 2019 04:28:13 -0700 (PDT)
Received: from donizetti.redhat.com ([2001:b07:6468:f312:f91e:ffe0:9205:3b26])
        by smtp.gmail.com with ESMTPSA id o14sm2601855wrp.77.2019.05.30.04.28.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 04:28:12 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, stefanha@redhat.com
Subject: [PATCH 0/2] scsi: add support for request batching
Date:   Thu, 30 May 2019 13:28:09 +0200
Message-Id: <20190530112811.3066-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows a list of requests to be issued, with the LLD only writing
the hardware doorbell when necessary, after the last request was prepared.
This is more efficient if we have lists of requests to issue, particularly
on virtualized hardware, where writing the doorbell is more expensive than
on real hardware.

This applies to any HBA, either singlequeue or multiqueue; the second
patch implements it for virtio-scsi.

Paolo

Paolo Bonzini (2):
  scsi_host: add support for request batching
  virtio_scsi: implement request batching

 drivers/scsi/scsi_lib.c    | 37 ++++++++++++++++++++++---
 drivers/scsi/virtio_scsi.c | 55 +++++++++++++++++++++++++++-----------
 include/scsi/scsi_cmnd.h   |  1 +
 include/scsi/scsi_host.h   | 16 +++++++++--
 4 files changed, 89 insertions(+), 20 deletions(-)

-- 
2.21.0

