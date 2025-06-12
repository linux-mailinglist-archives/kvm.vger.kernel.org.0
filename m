Return-Path: <kvm+bounces-49317-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 79BCEAD7CD1
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:00:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CA9A3A2F4E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 21:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D663E2D8799;
	Thu, 12 Jun 2025 21:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J5cEl65c"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C7B2D877C
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 21:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749762013; cv=none; b=eT9gbIlCk9ax/FnOQEHaxOeQQFKoTWlWkzBnU6FAROF0SAXRTVEerJHFjhQmesGlH896L++eDSw+POnoOL/OWiHIoZVtZkMDJIvFHFUI/2XoIsp3z+yBZhDDqTaC08vmB1EgQ4SwQSUoMK9QkYwsQDln2l9leZt9s6I0o0aiMg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749762013; c=relaxed/simple;
	bh=orDG+tM5dBYQPxmvFmUbXkgdLcK0uxufx+QC+uYLny8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNQeTHvYngNHJNqLkPt2XBWMndElODh9XPKviGqGDkmzOBLoK/FgK9TIJIayw7bnDytU+DfPN6pdA9Wi+zCLIFHE5SVC09pb41ZyHf8eNSjr8+aHnvI1BPannYhSF8VaQ8f56JBzKmKHYQGz8S6zU/CtSSYcTtflGDxfrQc6rqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J5cEl65c; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749762007;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=emNV1/voq8vLNxrXGL0MQiHgqI8v5/GVX6i/w8ik8zI=;
	b=J5cEl65cGkUBZRo1L9GCXTkDf44w/dUiAmxi4XkMnMHAuWhtNHeOSdP7tjNNAJ5yaFGzoS
	brzxqxv3rY2VIg6ushwmSLNidZtDs3v70DwWMYqmUutpfRNd5XGtiQULKbYzbibvtu7ucJ
	XJ2TvP1cQ4JO+DhcapNGEOOTJ4YDw7Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-124-FMI1iKeyOf-ip1YEUJLvsQ-1; Thu,
 12 Jun 2025 17:00:00 -0400
X-MC-Unique: FMI1iKeyOf-ip1YEUJLvsQ-1
X-Mimecast-MFC-AGG-ID: FMI1iKeyOf-ip1YEUJLvsQ_1749761996
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0E471956095;
	Thu, 12 Jun 2025 20:59:55 +0000 (UTC)
Received: from jsnow-thinkpadp16vgen1.westford.csb (unknown [10.22.80.54])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A265C1955F4A;
	Thu, 12 Jun 2025 20:59:26 +0000 (UTC)
From: John Snow <jsnow@redhat.com>
To: qemu-devel@nongnu.org
Cc: Joel Stanley <joel@jms.id.au>,
	Yi Liu <yi.l.liu@intel.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Fabiano Rosas <farosas@suse.de>,
	Alexander Bulekov <alxndr@bu.edu>,
	Darren Kenny <darren.kenny@oracle.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Ed Maste <emaste@freebsd.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Warner Losh <imp@bsdimp.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Tyrone Ting <kfting@nuvoton.com>,
	Eric Blake <eblake@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Troy Lee <leetroy@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Michael Roth <michael.roth@amd.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ani Sinha <anisinha@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Steven Lee <steven_lee@aspeedtech.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Li-Wen Hsu <lwhsu@freebsd.org>,
	Jamin Lin <jamin_lin@aspeedtech.com>,
	qemu-s390x@nongnu.org,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	qemu-block@nongnu.org,
	Bernhard Beschow <shentey@gmail.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	Maksim Davydov <davydov-max@yandex-team.ru>,
	Niek Linnenbank <nieklinnenbank@gmail.com>,
	=?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paul Durrant <paul@xen.org>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mitsyanko <i.mitsyanko@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Anton Johansson <anjo@rev.ng>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cleber Rosa <crosa@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Hao Wu <wuhaotsh@google.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Alessandro Di Federico <ale@rev.ng>,
	Thomas Huth <thuth@redhat.com>,
	Antony Pavlov <antonynpavlov@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Qiuhao Li <Qiuhao.Li@outlook.com>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	qemu-rust@nongnu.org,
	Bandan Das <bsd@redhat.com>,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Fam Zheng <fam@euphon.net>,
	Jia Liu <proljc@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair@alistair23.me>,
	Subbaraya Sundeep <sundeep.lkml@gmail.com>,
	Kyle Evans <kevans@freebsd.org>,
	Song Gao <gaosong@loongson.cn>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Peter Xu <peterx@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Radoslaw Biernacki <rad@semihalf.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ahmed Karaman <ahmedkhaledkaraman@gmail.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>
Subject: [PATCH v2 08/12] python: further 3.9+ syntax upgrades
Date: Thu, 12 Jun 2025 16:54:46 -0400
Message-ID: <20250612205451.1177751-9-jsnow@redhat.com>
In-Reply-To: <20250612205451.1177751-1-jsnow@redhat.com>
References: <20250612205451.1177751-1-jsnow@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

pyupgrade does not catch absolutely everything - there are still a few
deprecated type aliases we need to shift away from using.

Signed-off-by: John Snow <jsnow@redhat.com>
---
 docs/sphinx/compat.py                 | 8 ++------
 docs/sphinx/qapi_domain.py            | 6 +++---
 python/qemu/machine/console_socket.py | 4 ++--
 python/qemu/qmp/events.py             | 9 +++++++--
 python/qemu/qmp/protocol.py           | 3 +--
 python/qemu/utils/qemu_ga_client.py   | 4 ++--
 tests/qemu-iotests/fat16.py           | 3 ++-
 tests/qemu-iotests/iotests.py         | 8 ++++++--
 8 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/docs/sphinx/compat.py b/docs/sphinx/compat.py
index 2a93687cb3e..1eb1a49d976 100644
--- a/docs/sphinx/compat.py
+++ b/docs/sphinx/compat.py
@@ -2,13 +2,9 @@
 Sphinx cross-version compatibility goop
 """
 
+from collections.abc import Callable
 import re
-from typing import (
-    TYPE_CHECKING,
-    Any,
-    Callable,
-    Optional,
-)
+from typing import TYPE_CHECKING, Any, Optional
 
 from docutils import nodes
 from docutils.nodes import Element, Node, Text
diff --git a/docs/sphinx/qapi_domain.py b/docs/sphinx/qapi_domain.py
index cb6104922b5..7673eaed6d5 100644
--- a/docs/sphinx/qapi_domain.py
+++ b/docs/sphinx/qapi_domain.py
@@ -39,8 +39,8 @@
 
 
 if TYPE_CHECKING:
-    from collections.abc import Iterable
-    from typing import AbstractSet, Any
+    from collections.abc import Iterable, Set
+    from typing import Any
 
     from docutils.nodes import Element, Node
     from sphinx.addnodes import desc_signature, pending_xref
@@ -825,7 +825,7 @@ def clear_doc(self, docname: str) -> None:
                 del self.objects[fullname]
 
     def merge_domaindata(
-        self, docnames: AbstractSet[str], otherdata: dict[str, Any]
+        self, docnames: Set[str], otherdata: dict[str, Any]
     ) -> None:
         for fullname, obj in otherdata["objects"].items():
             if obj.docname in docnames:
diff --git a/python/qemu/machine/console_socket.py b/python/qemu/machine/console_socket.py
index 0754f340310..bcd27017fc9 100644
--- a/python/qemu/machine/console_socket.py
+++ b/python/qemu/machine/console_socket.py
@@ -17,7 +17,7 @@
 import socket
 import threading
 import time
-from typing import Deque, Optional
+from typing import Optional
 
 
 class ConsoleSocket(socket.socket):
@@ -43,7 +43,7 @@ def __init__(self,
 
         self._recv_timeout_sec = 300.0
         self._sleep_time = 0.5
-        self._buffer: Deque[int] = deque()
+        self._buffer: deque[int] = deque()
         if address is not None:
             socket.socket.__init__(self, socket.AF_UNIX, socket.SOCK_STREAM)
             self.connect(address)
diff --git a/python/qemu/qmp/events.py b/python/qemu/qmp/events.py
index e444d9334ec..33a9317e4d4 100644
--- a/python/qemu/qmp/events.py
+++ b/python/qemu/qmp/events.py
@@ -448,10 +448,15 @@ def accept(self, event) -> bool:
 """
 
 import asyncio
-from collections.abc import AsyncIterator, Iterable, Iterator
+from collections.abc import (
+    AsyncIterator,
+    Callable,
+    Iterable,
+    Iterator,
+)
 from contextlib import contextmanager
 import logging
-from typing import Callable, Optional, Union
+from typing import Optional, Union
 
 from .error import QMPError
 from .message import Message
diff --git a/python/qemu/qmp/protocol.py b/python/qemu/qmp/protocol.py
index 4ec9564c4b3..683df61f55e 100644
--- a/python/qemu/qmp/protocol.py
+++ b/python/qemu/qmp/protocol.py
@@ -15,7 +15,7 @@
 
 import asyncio
 from asyncio import StreamReader, StreamWriter
-from collections.abc import AsyncGenerator, Awaitable
+from collections.abc import AsyncGenerator, Awaitable, Callable
 from contextlib import asynccontextmanager
 from enum import Enum
 from functools import wraps
@@ -25,7 +25,6 @@
 from ssl import SSLContext
 from typing import (
     Any,
-    Callable,
     Generic,
     Optional,
     TypeVar,
diff --git a/python/qemu/utils/qemu_ga_client.py b/python/qemu/utils/qemu_ga_client.py
index a653c234c4b..d15848667b1 100644
--- a/python/qemu/utils/qemu_ga_client.py
+++ b/python/qemu/utils/qemu_ga_client.py
@@ -39,11 +39,11 @@
 import argparse
 import asyncio
 import base64
-from collections.abc import Sequence
+from collections.abc import Callable, Sequence
 import os
 import random
 import sys
-from typing import Any, Callable, Optional
+from typing import Any, Optional
 
 from qemu.qmp import ConnectError, SocketAddrT
 from qemu.qmp.legacy import QEMUMonitorProtocol
diff --git a/tests/qemu-iotests/fat16.py b/tests/qemu-iotests/fat16.py
index 88c3d56c662..ec4bc980725 100644
--- a/tests/qemu-iotests/fat16.py
+++ b/tests/qemu-iotests/fat16.py
@@ -15,8 +15,9 @@
 # You should have received a copy of the GNU General Public License
 # along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
+from collections.abc import Callable
 import string
-from typing import Callable, Optional, Protocol
+from typing import Optional, Protocol
 
 
 SECTOR_SIZE = 512
diff --git a/tests/qemu-iotests/iotests.py b/tests/qemu-iotests/iotests.py
index 104a61058fa..b69895cd117 100644
--- a/tests/qemu-iotests/iotests.py
+++ b/tests/qemu-iotests/iotests.py
@@ -20,7 +20,12 @@
 import atexit
 import bz2
 from collections import OrderedDict
-from collections.abc import Iterable, Iterator, Sequence
+from collections.abc import (
+    Callable,
+    Iterable,
+    Iterator,
+    Sequence,
+)
 from contextlib import contextmanager
 import faulthandler
 import json
@@ -35,7 +40,6 @@
 import time
 from typing import (
     Any,
-    Callable,
     Optional,
     TextIO,
     TypeVar,
-- 
2.48.1


