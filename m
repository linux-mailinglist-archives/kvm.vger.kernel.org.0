Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A61165E28
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgBTNGE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:06:04 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:28392 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728096AbgBTNGD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Feb 2020 08:06:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582203962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4cFZx3MMvL5YTnq3TreW86G7x/AmeK47tUPtRXUhNQM=;
        b=L5TzuvlpkO9uNIY8gj81K7CcZbG7p3r9T2ifsbNM9N5Q72TzoQgYvkdOVGYm71TozyRz1m
        jXctls1kEgKYuCTwdDizHLWhkCLEWq4I3G+oU4hyEVCoCN+nWsnhVtVFVdHbD9HCrcX1ur
        A1SmwcvhR1HkKMByA1fq99HZSHvJGuM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-TWaRNFNhM0eNq903i9Ik7A-1; Thu, 20 Feb 2020 08:05:59 -0500
X-MC-Unique: TWaRNFNhM0eNq903i9Ik7A-1
Received: by mail-wm1-f69.google.com with SMTP id g138so576732wmg.8
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:05:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4cFZx3MMvL5YTnq3TreW86G7x/AmeK47tUPtRXUhNQM=;
        b=rZkIGQXUFNZnLO+UjKaqdaJrNj8w7QmkCB8aXZHts+hX3pD+RfszCJVqwraDUHK48f
         bLcqboEqebsyHESmPBK1RI96GMTtAg+QtvEzHHFKEB74YqS/QZ73h3CrBq9mBapp5E9F
         nHuBzhQg/LhufQ/n7e1f8IGm5adZXpr4GYrZg4XEDdm36Mpu6oevhBF6V5RAJci0EJ3K
         7Jr8SI7t9VQToFF2Q5V+rgR78WwFlbj9YFtp94BTsRyIPQxHw1kW1mdWu6fycnELzuGl
         QjDOGSw/oQt1CGgZeNiLvlpJtN3E8LxvVAl6JxuBW7IBMujrwrj3m1OS5b3Mkcy88uIw
         Y1OA==
X-Gm-Message-State: APjAAAXPIPtN5E2RiIVCF963ivlgLjB8qhJKgKrIFSlOcbro18UWmIOI
        skkAj5q32UEVbXzmo0TU/+JvIsyXPCtsNoZtHU58NKYs7QCeI4fWVHG2Puy8NA5foNwRnyQn1zV
        VdgRxZjQwdNwi
X-Received: by 2002:a05:600c:3d1:: with SMTP id z17mr4707588wmd.90.1582203958358;
        Thu, 20 Feb 2020 05:05:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqw5jcBfwQCBB55iS//J5oZ4nyff+vZw9LvNNuT8fCe2PE+cfM3f9N7yqnDLu5ddD34rthBOSw==
X-Received: by 2002:a05:600c:3d1:: with SMTP id z17mr4707497wmd.90.1582203957647;
        Thu, 20 Feb 2020 05:05:57 -0800 (PST)
Received: from localhost.localdomain (78.red-88-21-202.staticip.rima-tde.net. [88.21.202.78])
        by smtp.gmail.com with ESMTPSA id b67sm4594690wmc.38.2020.02.20.05.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:05:57 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>, qemu-devel@nongnu.org
Cc:     "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Fam Zheng <fam@euphon.net>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Stefan Weil <sw@weilnetz.de>,
        Eric Auger <eric.auger@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        Aleksandar Rikalo <aleksandar.rikalo@rt-rk.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Michael Walle <michael@walle.cc>, qemu-ppc@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org,
        Alistair Francis <alistair@alistair23.me>,
        qemu-block@nongnu.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Jason Wang <jasowang@redhat.com>,
        xen-devel@lists.xenproject.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Richard Henderson <rth@twiddle.net>,
        John Snow <jsnow@redhat.com>
Subject: [PATCH v3 01/20] scripts/git.orderfile: Display Cocci scripts before code modifications
Date:   Thu, 20 Feb 2020 14:05:29 +0100
Message-Id: <20200220130548.29974-2-philmd@redhat.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200220130548.29974-1-philmd@redhat.com>
References: <20200220130548.29974-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we use a Coccinelle semantic script to do automatic
code modifications, it makes sense to look at the semantic
patch first.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 scripts/git.orderfile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/git.orderfile b/scripts/git.orderfile
index 1f747b583a..7cf22e0bf5 100644
--- a/scripts/git.orderfile
+++ b/scripts/git.orderfile
@@ -22,6 +22,9 @@ Makefile*
 qapi/*.json
 qga/*.json
 
+# semantic patches
+*.cocci
+
 # headers
 *.h
 
-- 
2.21.1

