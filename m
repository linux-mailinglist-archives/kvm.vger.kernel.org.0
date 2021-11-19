Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8193456C31
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 10:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbhKSJUI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 04:20:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40731 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232142AbhKSJUH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 04:20:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637313425;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4NZIzyK6JiWHKLm1sQkjynqfqZz8V1cyEV75QUaGKYQ=;
        b=CHVICIOSoK0v8KOY/z5+ewrSOtfRDZWma+Hl8W+po/cCES08eO8aH9JR1vR7JBnIu1zJiD
        FuRV3UHdoun2OCroIAcM7ap3ZuuJY6JB/xDtvU4PQIQqeD8SYVHrjaSa/pChg8D/nImDPL
        mh6uJTqOqQBpc40pwQJ6FLgW1grN4Wc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-uU6A49YyNQmU1a9KZ6l06A-1; Fri, 19 Nov 2021 04:17:04 -0500
X-MC-Unique: uU6A49YyNQmU1a9KZ6l06A-1
Received: by mail-wm1-f70.google.com with SMTP id m14-20020a05600c3b0e00b0033308dcc933so4427052wms.7
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 01:17:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4NZIzyK6JiWHKLm1sQkjynqfqZz8V1cyEV75QUaGKYQ=;
        b=ltIkWnrb+OjAsPHNpfVVyFm+sM/Ad4SM2EA0skqT+5PdI0uZgE5ekcjtRhGDlphab4
         K3neUkHc1+arad0+R6Jy1kNzZWmV+ZdisqakY7kM3fMeXrP8ev8qdZy0GepbLr4D3jQa
         R2wNzIOAn2Xt4c+W0cLvNoMNSW53gpKyJjGMgJw8rzmXwAMg5IL/M9v2F+9kuov9dX2B
         2uzZve21XnxfWAPXdUqWeDgax5YxBpdjWq2G38akJdSWM859ha/F/JE3BvJmQu/WXWaL
         3zPmq+HARguBXo2Uu+TdzrmFjPH75IZ4YDjK30S0r24q/Iuiaw0hzqsLuALyYDyWK/og
         iZyw==
X-Gm-Message-State: AOAM533thWtYiM02rBB9neo7Jns6ZvHCDkn92K7WgRXlMvBlDwt5DZ4h
        4u8HWjpT/VeKyvF9Ub3S9PihRgtvGtpg+LD/j5VLIWd0pOzuAnRo4deFMcMw5XwM0QqpHksly5s
        PhWTrWMn907Y9
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr5483869wrr.152.1637313423348;
        Fri, 19 Nov 2021 01:17:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6Y5V3FyKyLq/KwdcwKWSai2mVVd13KExMkN9JfsFYk/8RmDLs2COqae043WMruyWpO2AlFA==
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr5483832wrr.152.1637313423182;
        Fri, 19 Nov 2021 01:17:03 -0800 (PST)
Received: from x1w.. (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id o9sm2361300wrs.4.2021.11.19.01.17.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 01:17:02 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, John Snow <jsnow@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Michael Roth <michael.roth@amd.com>, qemu-block@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH-for-6.2? v2 0/3] misc: Spell QEMU all caps
Date:   Fri, 19 Nov 2021 10:16:58 +0100
Message-Id: <20211119091701.277973-1-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace Qemu -> QEMU.=0D
=0D
Supersedes: <20211118143401.4101497-1-philmd@redhat.com>=0D
=0D
Philippe Mathieu-Daud=C3=A9 (3):=0D
  docs: Spell QEMU all caps=0D
  misc: Spell QEMU all caps=0D
  qga: Spell QEMU all caps=0D
=0D
 docs/devel/modules.rst                 |  2 +-=0D
 docs/devel/multi-thread-tcg.rst        |  2 +-=0D
 docs/devel/style.rst                   |  2 +-=0D
 docs/devel/ui.rst                      |  4 ++--=0D
 docs/interop/nbd.txt                   |  6 +++---=0D
 docs/interop/qcow2.txt                 |  8 ++++----=0D
 docs/multiseat.txt                     |  2 +-=0D
 docs/system/device-url-syntax.rst.inc  |  2 +-=0D
 docs/system/i386/sgx.rst               | 26 +++++++++++++-------------=0D
 docs/u2f.txt                           |  2 +-=0D
 qapi/block-core.json                   |  2 +-=0D
 python/qemu/machine/machine.py         |  2 +-=0D
 qga/installer/qemu-ga.wxs              |  6 +++---=0D
 scripts/checkpatch.pl                  |  2 +-=0D
 scripts/render_block_graph.py          |  2 +-=0D
 scripts/simplebench/bench-backup.py    |  4 ++--=0D
 scripts/simplebench/bench_block_job.py |  2 +-=0D
 target/hexagon/README                  |  2 +-=0D
 tests/guest-debug/run-test.py          |  4 ++--=0D
 tests/qemu-iotests/testenv.py          |  2 +-=0D
 20 files changed, 42 insertions(+), 42 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

