Return-Path: <kvm+bounces-771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E653F7E270F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 15:36:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1F7581C20C01
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:36:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9B128E3A;
	Mon,  6 Nov 2023 14:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108BB28E0A
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 14:36:17 +0000 (UTC)
Received: from smtp-fw-52002.amazon.com (smtp-fw-52002.amazon.com [52.119.213.150])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBD3C6
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 06:36:15 -0800 (PST)
X-IronPort-AV: E=Sophos;i="6.03,281,1694736000"; 
   d="scan'208";a="593337518"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-1197e3af.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52002.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2023 14:36:13 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan2.pdx.amazon.com [10.39.38.66])
	by email-inbound-relay-pdx-2a-m6i4x-1197e3af.us-west-2.amazon.com (Postfix) with ESMTPS id 1D23922B010;
	Mon,  6 Nov 2023 14:36:09 +0000 (UTC)
Received: from EX19MTAUWA002.ant.amazon.com [10.0.38.20:26365]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.37.121:2525] with esmtp (Farcaster)
 id e345a6ca-52b1-4100-bbdc-3568478e064d; Mon, 6 Nov 2023 14:36:09 +0000 (UTC)
X-Farcaster-Flow-ID: e345a6ca-52b1-4100-bbdc-3568478e064d
Received: from EX19MTAUWB001.ant.amazon.com (10.250.64.248) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.39; Mon, 6 Nov 2023 14:36:04 +0000
Received: from u3832b3a9db3152.ant.amazon.com (10.106.83.6) by
 mail-relay.amazon.com (10.250.64.254) with Microsoft SMTP Server id
 15.2.1118.39 via Frontend Transport; Mon, 6 Nov 2023 14:36:01 +0000
From: David Woodhouse <dwmw2@infradead.org>
To: <qemu-devel@nongnu.org>
CC: Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>, Peter
 Maydell <peter.maydell@linaro.org>, Stefano Stabellini
	<sstabellini@kernel.org>, Anthony Perard <anthony.perard@citrix.com>, Paul
 Durrant <paul@xen.org>, =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?=
	<marcandre.lureau@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Richard
 Henderson <richard.henderson@linaro.org>, Eduardo Habkost
	<eduardo@habkost.net>, "Michael S. Tsirkin" <mst@redhat.com>, Marcel
 Apfelbaum <marcel.apfelbaum@gmail.com>, Jason Wang <jasowang@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, <qemu-block@nongnu.org>,
	<xen-devel@lists.xenproject.org>, <kvm@vger.kernel.org>
Subject: [PATCH v4 16/17] doc/sphinx/hxtool.py: add optional label argument to SRST directive
Date: Mon, 6 Nov 2023 14:35:06 +0000
Message-ID: <20231106143507.1060610-17-dwmw2@infradead.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231106143507.1060610-1-dwmw2@infradead.org>
References: <20231106143507.1060610-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: Bulk

From: David Woodhouse <dwmw@amazon.co.uk>

We can't just embed labels directly into files like qemu-options.hx which
are included from multiple top-level RST files, because Sphinx sees the
labels as duplicate: https://github.com/sphinx-doc/sphinx/issues/9707

So add an 'emitrefs' option to the Sphinx hxtool-doc directive, which is
set only in invocation.rst and not from the HTML rendition of the man
page. Along with an argument to the SRST directive which causes a label
of the form '.. _LABEL-reference-label:' to be emitted when the emitrefs
option is set.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 docs/sphinx/hxtool.py      | 18 +++++++++++++++++-
 docs/system/invocation.rst |  1 +
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/docs/sphinx/hxtool.py b/docs/sphinx/hxtool.py
index 9f6b9d87dc..bfb0929573 100644
--- a/docs/sphinx/hxtool.py
+++ b/docs/sphinx/hxtool.py
@@ -78,18 +78,28 @@ def parse_archheading(file, lnum, line):
         serror(file, lnum, "Invalid ARCHHEADING line")
     return match.group(1)
 
+def parse_srst(file, lnum, line):
+    """Handle an SRST directive"""
+    # The input should be "SRST(label)".
+    match = re.match(r'SRST\((.*?)\)', line)
+    if match is None:
+        serror(file, lnum, "Invalid SRST line")
+    return match.group(1)
+
 class HxtoolDocDirective(Directive):
     """Extract rST fragments from the specified .hx file"""
     required_argument = 1
     optional_arguments = 1
     option_spec = {
-        'hxfile': directives.unchanged_required
+        'hxfile': directives.unchanged_required,
+        'emitrefs': directives.flag
     }
     has_content = False
 
     def run(self):
         env = self.state.document.settings.env
         hxfile = env.config.hxtool_srctree + '/' + self.arguments[0]
+        emitrefs = "emitrefs" in self.options
 
         # Tell sphinx of the dependency
         env.note_dependency(os.path.abspath(hxfile))
@@ -113,6 +123,12 @@ def run(self):
                         serror(hxfile, lnum, 'expected ERST, found SRST')
                     else:
                         state = HxState.RST
+                        if emitrefs and line != "SRST":
+                            label = parse_srst(hxfile, lnum, line)
+                            if label != "":
+                                rstlist.append("", hxfile, lnum - 1)
+                                refline = ".. _" + label + "-reference-label:"
+                                rstlist.append(refline, hxfile, lnum - 1)
                 elif directive == 'ERST':
                     if state == HxState.CTEXT:
                         serror(hxfile, lnum, 'expected SRST, found ERST')
diff --git a/docs/system/invocation.rst b/docs/system/invocation.rst
index 4ba38fc23d..ef75dad2e2 100644
--- a/docs/system/invocation.rst
+++ b/docs/system/invocation.rst
@@ -11,6 +11,7 @@ disk_image is a raw hard disk image for IDE hard disk 0. Some targets do
 not need a disk image.
 
 .. hxtool-doc:: qemu-options.hx
+    :emitrefs:
 
 Device URL Syntax
 ~~~~~~~~~~~~~~~~~
-- 
2.34.1


