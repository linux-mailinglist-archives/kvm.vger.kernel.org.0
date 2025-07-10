Return-Path: <kvm+bounces-52036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 14667B00177
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 14:17:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D8DF11C8811F
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 12:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534C72505BA;
	Thu, 10 Jul 2025 12:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MpF306nn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF6D41C71
	for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 12:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752149832; cv=none; b=hvfZaQCAuNf4vZpy/Rumx4MXYs8Tit5ZocDFw5HF6V2NRP6cHMIa/KhTzHzirg4+3fmgnejNoGYmlcI5UXxpmSZDvm72+dFZ8EqUazhCLsAdMglPnsHUPbVOexg/I0q4LMxUwmCtf9IiEE05Be3tKQPs6GN8O1EaaAC5kPV805o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752149832; c=relaxed/simple;
	bh=VjfCuE+U8/TRP5Ba0o0oxRmFLOu1p/4UQMt2xvHr20w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vaqrq6A1mbaJz5ygPYFjJadZQErN8LfbXsiAs/DBgjJdjjFhJRGY0EKDCmzm5if2SljbK0WB5+rZ3Y50H1znxfL9MjgmphiI568oZEWnUAEXG0oVsIilXjW+0JIojPcy6f7wtK5TOJd2/IhyxtsPoj0CPxI6LO1u3Gs0oVf6h+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MpF306nn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752149829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p3er1+S1ghqVmC558ORCh1Xcymb4Uf9m+2L2EUwIcoU=;
	b=MpF306nnQgAZn+bxcABCfIMXJZh2xzos0PH/AEFVUHsfXkmYhC1OHRl2n1saQhu39uziGb
	zJ7C/7cq2De+7021cgDR9yo+NlYZGmSiW4qUa1ol0Tv/xNMcoFa5H48bDNhgJzU6WSAgFP
	3HHEDwVq3rKoCD5mNk3Tlf8khgRrBtQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-103-nkj96xV3NyKnbAJI-mOrKw-1; Thu,
 10 Jul 2025 08:17:05 -0400
X-MC-Unique: nkj96xV3NyKnbAJI-mOrKw-1
X-Mimecast-MFC-AGG-ID: nkj96xV3NyKnbAJI-mOrKw_1752149824
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8AD419560B0;
	Thu, 10 Jul 2025 12:17:03 +0000 (UTC)
Received: from thuth-p1g4.redhat.com (unknown [10.45.224.72])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 551A5195607A;
	Thu, 10 Jul 2025 12:16:59 +0000 (UTC)
From: Thomas Huth <thuth@redhat.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: [PATCH] powerpc: Replace the obsolete address of the FSF
Date: Thu, 10 Jul 2025 14:16:57 +0200
Message-ID: <20250710121657.169969-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

From: Thomas Huth <thuth@redhat.com>

The FSF does not reside in the Franklin street anymore. Let's update
the address with the link to their website, as suggested in the latest
revision of the GPL-2.0 license.
(See https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt for example)

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 arch/powerpc/boot/crtsavres.S            | 5 ++---
 arch/powerpc/include/uapi/asm/eeh.h      | 5 ++---
 arch/powerpc/include/uapi/asm/kvm.h      | 5 ++---
 arch/powerpc/include/uapi/asm/kvm_para.h | 5 ++---
 arch/powerpc/include/uapi/asm/ps3fb.h    | 3 +--
 arch/powerpc/lib/crtsavres.S             | 5 ++---
 arch/powerpc/xmon/ppc.h                  | 5 +++--
 7 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/boot/crtsavres.S b/arch/powerpc/boot/crtsavres.S
index 085fb2b9a8b89..a710a49a5dbca 100644
--- a/arch/powerpc/boot/crtsavres.S
+++ b/arch/powerpc/boot/crtsavres.S
@@ -26,9 +26,8 @@
  * General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.  If not, write to
- * the Free Software Foundation, 51 Franklin Street, Fifth Floor,
- * Boston, MA 02110-1301, USA.
+ * along with this program; see the file COPYING.  If not, see
+ * <https://www.gnu.org/licenses/>.
  *
  *    As a special exception, if you link this library with files
  *    compiled with GCC to produce an executable, this does not cause
diff --git a/arch/powerpc/include/uapi/asm/eeh.h b/arch/powerpc/include/uapi/asm/eeh.h
index 28186071fafc4..4a117cc475299 100644
--- a/arch/powerpc/include/uapi/asm/eeh.h
+++ b/arch/powerpc/include/uapi/asm/eeh.h
@@ -9,9 +9,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <https://www.gnu.org/licenses/>.
  *
  * Copyright IBM Corp. 2015
  *
diff --git a/arch/powerpc/include/uapi/asm/kvm.h b/arch/powerpc/include/uapi/asm/kvm.h
index eaeda001784eb..75c1d7a48ad52 100644
--- a/arch/powerpc/include/uapi/asm/kvm.h
+++ b/arch/powerpc/include/uapi/asm/kvm.h
@@ -9,9 +9,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <https://www.gnu.org/licenses/>.
  *
  * Copyright IBM Corp. 2007
  *
diff --git a/arch/powerpc/include/uapi/asm/kvm_para.h b/arch/powerpc/include/uapi/asm/kvm_para.h
index a809b1b44ddfe..66d1e17e427a6 100644
--- a/arch/powerpc/include/uapi/asm/kvm_para.h
+++ b/arch/powerpc/include/uapi/asm/kvm_para.h
@@ -9,9 +9,8 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, see <https://www.gnu.org/licenses/>.
  *
  * Copyright IBM Corp. 2008
  *
diff --git a/arch/powerpc/include/uapi/asm/ps3fb.h b/arch/powerpc/include/uapi/asm/ps3fb.h
index fd7e3a0d35d57..af6322042b3b0 100644
--- a/arch/powerpc/include/uapi/asm/ps3fb.h
+++ b/arch/powerpc/include/uapi/asm/ps3fb.h
@@ -13,8 +13,7 @@
  * General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * with this program; if not, see <https://www.gnu.org/licenses/>.
  */
 
 #ifndef _ASM_POWERPC_PS3FB_H_
diff --git a/arch/powerpc/lib/crtsavres.S b/arch/powerpc/lib/crtsavres.S
index 8967903c15e99..c7e58b6614169 100644
--- a/arch/powerpc/lib/crtsavres.S
+++ b/arch/powerpc/lib/crtsavres.S
@@ -27,9 +27,8 @@
  * General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; see the file COPYING.  If not, write to
- * the Free Software Foundation, 51 Franklin Street, Fifth Floor,
- * Boston, MA 02110-1301, USA.
+ * along with this program; see the file COPYING.  If not, see
+ * <https://www.gnu.org/licenses/>.
  *
  *    As a special exception, if you link this library with files
  *    compiled with GCC to produce an executable, this does not cause
diff --git a/arch/powerpc/xmon/ppc.h b/arch/powerpc/xmon/ppc.h
index 1d98b8dd134ef..270097f6e905b 100644
--- a/arch/powerpc/xmon/ppc.h
+++ b/arch/powerpc/xmon/ppc.h
@@ -15,8 +15,9 @@ warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
 the GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
-along with this file; see the file COPYING.  If not, write to the Free
-Software Foundation, 51 Franklin Street - Fifth Floor, Boston, MA 02110-1301, USA.  */
+along with this file; see the file COPYING.  If not, see
+<https://www.gnu.org/licenses/>.
+*/
 
 #ifndef PPC_H
 #define PPC_H
-- 
2.50.0


