Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF5E425796
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242593AbhJGQTY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:19:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242615AbhJGQTU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623446;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GNtxCZGvnxhj0iwK4swW8c7ZuwhRSlRGtvMCk2ldQWo=;
        b=UDanCsrUlicmLwzJFjipavM2CA6Agmb5NVYgHuOtxacV8qiMbAvwLNCSf5DfDTpkdvG+a7
        hl3FcrnwfIA5g/r+n2IUzVqRJgRBy0wD4Fd+CF4slME5ZKhlxWUTpX4Dfj9sF0eoToJ8m+
        26fbgfWQO72+rSF4fElIdfY3mM/sM1g=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-347-WNg147S6NJyC8T_mWncLgw-1; Thu, 07 Oct 2021 12:17:24 -0400
X-MC-Unique: WNg147S6NJyC8T_mWncLgw-1
Received: by mail-wr1-f71.google.com with SMTP id d13-20020adf9b8d000000b00160a94c235aso5128640wrc.2
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GNtxCZGvnxhj0iwK4swW8c7ZuwhRSlRGtvMCk2ldQWo=;
        b=cbk3SKYhMAdQMAf34PtuPZdfq6DAWcUlINVrByOVVDft5+9V9pEO+Ar1R2PC10j3Oa
         Nca6i2Bou9S2Bv16uIkVdarPa3uj6Vhm32C4CAg8HHTYFTYfA1NsDCFhVdYXOmU1wk2Z
         h4Psoh+QDUk92JOZ2dVn2X9ecbQsbokjDW/ynyJpO7RL3wupKSAr+9IGM68VVW9DvnOt
         iAyMk6Gb1mG154iY4A6LiQbKmnXt209Lzm7jdNWSoMPo/WNv4Zv7ZleIg1S6L804FvlJ
         Ak9OMb203qpy+ZBnkQKc1uJZSRyp9VFku3gQpIxhKPqz8NELbKZi3bUoVb+CEGudapr4
         mvFA==
X-Gm-Message-State: AOAM530Gye9X0pUc+qMmfXe8fKM99XMMUie8Du8f3mkMjL9sERLn4k/1
        buiwF1X5+/xb+xWYduJU/fN7plb4lWRh2M89C/msOljWqXVZs+xZprhXdSUaOi56uo9Lyu/sFFK
        QtRHnUlCASgT2
X-Received: by 2002:adf:a15c:: with SMTP id r28mr6657722wrr.287.1633623443180;
        Thu, 07 Oct 2021 09:17:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+RMzqKfLp1HEW7IFDLlNjEi/iRuCQ1sFP+CVWglEu2hUVLxRR+2IyjSGZpZn9KcPO5riLYQ==
X-Received: by 2002:adf:a15c:: with SMTP id r28mr6657700wrr.287.1633623443022;
        Thu, 07 Oct 2021 09:17:23 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id d8sm48710wrz.84.2021.10.07.09.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:22 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Subject: [PATCH v4 01/23] qapi/misc-target: Wrap long 'SEV Attestation Report' long lines
Date:   Thu,  7 Oct 2021 18:16:54 +0200
Message-Id: <20211007161716.453984-2-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Wrap long lines before 70 characters for legibility.

Suggested-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 qapi/misc-target.json | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 594fbd1577f..ae5577e0390 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -300,8 +300,8 @@
 ##
 # @SevAttestationReport:
 #
-# The struct describes attestation report for a Secure Encrypted Virtualization
-# feature.
+# The struct describes attestation report for a Secure Encrypted
+# Virtualization feature.
 #
 # @data:  guest attestation report (base64 encoded)
 #
@@ -315,10 +315,11 @@
 ##
 # @query-sev-attestation-report:
 #
-# This command is used to get the SEV attestation report, and is supported on AMD
-# X86 platforms only.
+# This command is used to get the SEV attestation report, and is
+# supported on AMD X86 platforms only.
 #
-# @mnonce: a random 16 bytes value encoded in base64 (it will be included in report)
+# @mnonce: a random 16 bytes value encoded in base64 (it will be
+#          included in report)
 #
 # Returns: SevAttestationReport objects.
 #
@@ -326,11 +327,13 @@
 #
 # Example:
 #
-# -> { "execute" : "query-sev-attestation-report", "arguments": { "mnonce": "aaaaaaa" } }
+# -> { "execute" : "query-sev-attestation-report",
+#                  "arguments": { "mnonce": "aaaaaaa" } }
 # <- { "return" : { "data": "aaaaaaaabbbddddd"} }
 #
 ##
-{ 'command': 'query-sev-attestation-report', 'data': { 'mnonce': 'str' },
+{ 'command': 'query-sev-attestation-report',
+  'data': { 'mnonce': 'str' },
   'returns': 'SevAttestationReport',
   'if': 'TARGET_I386' }
 
-- 
2.31.1

