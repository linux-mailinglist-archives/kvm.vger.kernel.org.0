Return-Path: <kvm+bounces-57993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0C2B841B9
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 12:33:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ED48627500
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 10:32:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C8A129B22F;
	Thu, 18 Sep 2025 10:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FxETtJFN"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7059F2F5A14
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 10:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758191419; cv=none; b=vDnGgqXHxaDrkO75/1qto/EkMa6SZzNl+aYBLws3ONfdEJ7Pb15hlxEROuq85GdPe7etAY42e5kycs3xjUnrV/Bj4gmtDfwm8ieEOK3AIa4T+7QtoeHERaSRdAJGjCNba+PkHyBSuPxdJ91OL4upQoJc2RzlGzY/UjLTcGRDMa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758191419; c=relaxed/simple;
	bh=dP5IVGjmx5XftVX1vvgwnPL2aJr8KldT3GTZjykn2Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnDjJ2207gs8O+Z1snK9lvI6dsDp57dRVr91HnUDp1vjtWq25ufGkwK+8kOqdVjoRdJvuPg0mPD6z9D3SALhtbRULqgrgu3WNMjjEOBYs85TOFZFpIIW+toa9MEJj3W0vOqMZ6+GVsgJlmLgeG73mWtcqUCWX49HmQmV1wOhors=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FxETtJFN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A21C4CEEB;
	Thu, 18 Sep 2025 10:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758191419;
	bh=dP5IVGjmx5XftVX1vvgwnPL2aJr8KldT3GTZjykn2Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxETtJFNX+jmX13mn+mvbN73JIqE8L+LWqtqxPRi+hcnfiNCAIgtQIQi03hpsMleg
	 JekZvLZLPomHv0Wfk7jSHFbkFjZkUoiyMnDqRFf5kfH67tErPgpE1RUAfOWXU8yy+0
	 rrspUlJbzZKUGMdzy5B9SZ+qNL9fVATB8H2/fmQZku/ZOuU5fVF++g+GzLvw4QK4l+
	 94Tbgvqx1ULaLWhhONyFzKIWP/wrg9BFhZZqrxmltbYaQPExgo4TW96JuNqKbTlqqR
	 A1oGzWW0QUyumi8qOTrz2IiN6niHLWC4j9vHnCsNNwjx0PC9u3ctd9t6pKFvJyxLy9
	 uCl512O8rmmQg==
From: "Naveen N Rao (AMD)" <naveen@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Daniel P. Berrange" <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Roy Hopkins <roy.hopkins@randomman.co.uk>
Subject: [PATCH 2/8] target/i386: SEV: Ensure SEV features are only set through qemu cli or IGVM
Date: Thu, 18 Sep 2025 15:57:00 +0530
Message-ID: <f9b23c74b04177f0dc088a246bdacf1cb158c35e.1758189463.git.naveen@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758189463.git.naveen@kernel.org>
References: <cover.1758189463.git.naveen@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for qemu being able to set SEV features through the cli,
add a check to ensure that SEV features are not also set if using IGVM
files.

Signed-off-by: Naveen N Rao (AMD) <naveen@kernel.org>
---
 target/i386/sev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 2fb1268ed788..c4011a6f2ef7 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1901,6 +1901,11 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
          * as SEV_STATE_UNINIT.
          */
         if (x86machine->igvm) {
+            if (sev_common->sev_features & ~SVM_SEV_FEAT_SNP_ACTIVE) {
+                error_setg(errp, "%s: SEV features can't be specified when using IGVM files",
+                           __func__);
+                return -1;
+            }
             if (IGVM_CFG_GET_CLASS(x86machine->igvm)
                     ->process(x86machine->igvm, machine->cgs, true, errp) ==
                 -1) {
-- 
2.51.0


