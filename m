Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7F227B39D
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgI1RuQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726548AbgI1RuP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:15 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=79YO6fZ0Yrs5YdJ8AKm+SuqO4tnr4tmPibQXRa3Gx68=;
        b=DYVDu5vnCgQEVKGAbTFnCtwJFZfq1Nd5vNF9uxBmvXYHq57yQ6inwwi7FwQSAK9VrICkjb
        s8nUieLpDdosqc4phXAbtYCf9UMWkpZduMhSjRTlEllzjoinsfjl13yBcp2ZwIGVK0mnfJ
        wuAlnumeb1lN0bfszlDyCNX8tKOjPi4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-oChg-JtBPVa8oSWNenBlgA-1; Mon, 28 Sep 2020 13:50:09 -0400
X-MC-Unique: oChg-JtBPVa8oSWNenBlgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8F35E425D5;
        Mon, 28 Sep 2020 17:50:08 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38DD510013C0;
        Mon, 28 Sep 2020 17:50:06 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 03/11] configure: Add a check for the bash version
Date:   Mon, 28 Sep 2020 19:49:50 +0200
Message-Id: <20200928174958.26690-4-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our scripts do not work with older versions of the bash, like the
default Bash 3 from macOS (e.g. we use the "|&" operator which has
been introduced in Bash 4.0). Add a check to make sure that we use
at least version 4 to avoid that the users run into problems later.

Message-Id: <20200925143852.227908-1-thuth@redhat.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 configure | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/configure b/configure
index f930543..39b63ae 100755
--- a/configure
+++ b/configure
@@ -1,5 +1,10 @@
 #!/usr/bin/env bash
 
+if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
+    echo "Error: Bash version 4 or newer is required for the kvm-unit-tests"
+    exit 1
+fi
+
 srcdir=$(cd "$(dirname "$0")"; pwd)
 prefix=/usr/local
 cc=gcc
-- 
2.18.2

