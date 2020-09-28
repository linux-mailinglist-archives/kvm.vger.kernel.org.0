Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7F927B3A2
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 19:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgI1RuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 13:50:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726648AbgI1RuW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 28 Sep 2020 13:50:22 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601315421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=CsHCQ6zqnhsBmNQoKLpNTTHjsBNXMnS9r1fYUgjBzBE=;
        b=d5BQLHNp6HbqThktIK0gc6w78nklQ9p/iHAdrw/zqpEaeNOZWqSUDjRgePsqrtBYPR3KIf
        SIx4IOdt7y2I44rcJytNG1qragpf2kFIlz406Bq40HdtXiuPxug7OQFkOpOt9cNbDAf39F
        YNnVtUt5lreQr1H5jqyEzYwBOsoS8ys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-JmGs5MryMl6Jlm0orTJTUw-1; Mon, 28 Sep 2020 13:50:19 -0400
X-MC-Unique: JmGs5MryMl6Jlm0orTJTUw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 477E41084D75;
        Mon, 28 Sep 2020 17:50:18 +0000 (UTC)
Received: from thuth.com (unknown [10.40.192.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2812510013C0;
        Mon, 28 Sep 2020 17:50:16 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PULL 08/11] run_tests/mkstandalone: add arch_cmd hook
Date:   Mon, 28 Sep 2020 19:49:55 +0200
Message-Id: <20200928174958.26690-9-thuth@redhat.com>
In-Reply-To: <20200928174958.26690-1-thuth@redhat.com>
References: <20200928174958.26690-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Hartmayer <mhartmay@linux.ibm.com>

This allows us, for example, to auto generate a new test case based on
an existing test case.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Message-Id: <20200923134758.19354-4-mhartmay@linux.ibm.com>
Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 scripts/common.bash | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/scripts/common.bash b/scripts/common.bash
index c7acdf1..a6044b7 100644
--- a/scripts/common.bash
+++ b/scripts/common.bash
@@ -19,7 +19,7 @@ function for_each_unittest()
 	while read -r -u $fd line; do
 		if [[ "$line" =~ ^\[(.*)\]$ ]]; then
 			if [ -n "${testname}" ]; then
-				"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+				$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 			fi
 			testname=${BASH_REMATCH[1]}
 			smp=1
@@ -49,11 +49,16 @@ function for_each_unittest()
 		fi
 	done
 	if [ -n "${testname}" ]; then
-		"$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
+		$(arch_cmd) "$cmd" "$testname" "$groups" "$smp" "$kernel" "$opts" "$arch" "$check" "$accel" "$timeout"
 	fi
 	exec {fd}<&-
 }
 
+function arch_cmd()
+{
+	[ "${ARCH_CMD}" ] && echo "${ARCH_CMD}"
+}
+
 # The current file has to be the only file sourcing the arch helper
 # file
 ARCH_FUNC=scripts/${ARCH}/func.bash
-- 
2.18.2

