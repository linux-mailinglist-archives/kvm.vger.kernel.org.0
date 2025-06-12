Return-Path: <kvm+bounces-49312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC02AD7CBE
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 22:57:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2DD03A712C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 20:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249352D8786;
	Thu, 12 Jun 2025 20:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a2pLrqWE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06D42D8780
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 20:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749761851; cv=none; b=hSrv26WochfaJVmFWPk+A5kknMZ7OTVmFJO0528OSuaYU1MYzsB864XdbGjQb13X6qhTVFUGdfK5mL4SpOge4/h+Z0zSrhW+j40jBzweZ6mJYgVMakB4ZXNx9xFM0v2+06UznhxhisDMfJpRntS8y6Z4Vn5CwMkkbIl/Sc/HPkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749761851; c=relaxed/simple;
	bh=M++0lP/kmHd2YJYPK+M4XvpyaUrICG6O3ggxpIQQq8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AaEG2TO9d2GA8oJVyvjeMknAm57TOIdzVAb2R3g+Nyp1NAhWgyWuSDqRJfD6zfO7K7nphGLUxMO4+OWZW6PF5p0kxKfzjPAttqQzMF9ekjfcbHPVbqyZ9z3/peGQNOEbxTvlaUgzDGCUUrN9bEwbOeXzHKWTTW23c6Oc2KYujuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a2pLrqWE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749761846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ptNkouiIlmQG4AXcDpXgcIVBYZMq5dIh+4uMldJ3t1Q=;
	b=a2pLrqWEnSd5aULN+EGQsUD0UeYJpP3Zcfn41FysIdn/CaxIqwbEhaO4rcnDmSDuMKUFgy
	pP5mVy53LJTGUZ2aBsSr5p4M0ZXqrI5+94AWVNfoX06SYuVHdYMtxUqaC2GB0xNlIJ4duN
	CHehiHDz89FWzxKd6KEYwn9h4onh21A=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-478-pf6xO6nuN_SNwNxR6bQdng-1; Thu,
 12 Jun 2025 16:57:24 -0400
X-MC-Unique: pf6xO6nuN_SNwNxR6bQdng-1
X-Mimecast-MFC-AGG-ID: pf6xO6nuN_SNwNxR6bQdng_1749761839
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7416619560AB;
	Thu, 12 Jun 2025 20:57:18 +0000 (UTC)
Received: from jsnow-thinkpadp16vgen1.westford.csb (unknown [10.22.80.54])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BACED1955F4A;
	Thu, 12 Jun 2025 20:56:42 +0000 (UTC)
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
Subject: [PATCH v2 03/12] python: sync changes from external qemu.qmp package
Date: Thu, 12 Jun 2025 16:54:41 -0400
Message-ID: <20250612205451.1177751-4-jsnow@redhat.com>
In-Reply-To: <20250612205451.1177751-1-jsnow@redhat.com>
References: <20250612205451.1177751-1-jsnow@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Synchronize changes from the standalone python-qemu-qmp repository for
the primary purpose of removing some pre-3.9 compatibility crud that we
no longer need or want.

My plan for this release cycle is to finally eliminate this duplication
so this type of patch will no longer be necessary -- but for now, it is.

NB: A few changes are not synchronized; mostly license and documentation
strings. Everything functional is fully copied verbatim. The license
strings are not sync'd only because they point to different LICENSE
filenames for the different repositories.

Signed-off-by: John Snow <jsnow@redhat.com>
---
 python/qemu/qmp/error.py      |   7 +-
 python/qemu/qmp/events.py     |  50 ++++++++--
 python/qemu/qmp/legacy.py     |  16 +++-
 python/qemu/qmp/message.py    |  22 +++--
 python/qemu/qmp/models.py     |   6 +-
 python/qemu/qmp/protocol.py   | 169 +++++++++++++++++++++-------------
 python/qemu/qmp/qmp_client.py | 133 +++++++++++++++++++-------
 python/qemu/qmp/qmp_shell.py  | 167 +++++++++++++++++++++++----------
 python/qemu/qmp/qmp_tui.py    |  34 +++++--
 python/qemu/qmp/util.py       | 116 ++---------------------
 python/tests/protocol.py      |  10 +-
 11 files changed, 443 insertions(+), 287 deletions(-)

diff --git a/python/qemu/qmp/error.py b/python/qemu/qmp/error.py
index 24ba4d50541..c87b078f620 100644
--- a/python/qemu/qmp/error.py
+++ b/python/qemu/qmp/error.py
@@ -44,7 +44,10 @@ class ProtocolError(QMPError):
 
     :param error_message: Human-readable string describing the error.
     """
-    def __init__(self, error_message: str):
-        super().__init__(error_message)
+    def __init__(self, error_message: str, *args: object):
+        super().__init__(error_message, *args)
         #: Human-readable error message, without any prefix.
         self.error_message: str = error_message
+
+    def __str__(self) -> str:
+        return self.error_message
diff --git a/python/qemu/qmp/events.py b/python/qemu/qmp/events.py
index 6199776cc66..cfb5f0ac621 100644
--- a/python/qemu/qmp/events.py
+++ b/python/qemu/qmp/events.py
@@ -12,7 +12,14 @@
 ----------------------
 
 In all of the following examples, we assume that we have a `QMPClient`
-instantiated named ``qmp`` that is already connected.
+instantiated named ``qmp`` that is already connected. For example:
+
+.. code:: python
+
+   from qemu.qmp import QMPClient
+
+   qmp = QMPClient('example-vm')
+   await qmp.connect('127.0.0.1', 1234)
 
 
 `listener()` context blocks with one name
@@ -87,7 +94,9 @@
            event = listener.get()
            print(f"Event arrived: {event['event']}")
 
-This event stream will never end, so these blocks will never terminate.
+This event stream will never end, so these blocks will never
+terminate. Even if the QMP connection errors out prematurely, this
+listener will go silent without raising an error.
 
 
 Using asyncio.Task to concurrently retrieve events
@@ -227,16 +236,20 @@ async def print_events(listener):
 .. code:: python
 
    await qmp.execute('stop')
-   qmp.events.clear()
+   discarded = qmp.events.clear()
    await qmp.execute('cont')
    event = await qmp.events.get()
    assert event['event'] == 'RESUME'
+   assert discarded[0]['event'] == 'STOP'
 
 `EventListener` objects are FIFO queues. If events are not consumed,
 they will remain in the queue until they are witnessed or discarded via
 `clear()`. FIFO queues will be drained automatically upon leaving a
 context block, or when calling `remove_listener()`.
 
+Any events removed from the queue in this fashion will be returned by
+the clear call.
+
 
 Accessing listener history
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
@@ -350,6 +363,12 @@ def filter(event: Message) -> bool:
                break
 
 
+Note that in the above example, we explicitly wait on jobA to conclude
+first, and then wait for jobB to do the same. All we have guaranteed is
+that the code that waits for jobA will not accidentally consume the
+event intended for the jobB waiter.
+
+
 Extending the `EventListener` class
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
@@ -407,13 +426,13 @@ def accept(self, event) -> bool:
 These interfaces are not ones I am sure I will keep or otherwise modify
 heavily.
 
-qmp.listener()’s type signature
+qmp.listen()’s type signature
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-`listener()` does not return anything, because it was assumed the caller
+`listen()` does not return anything, because it was assumed the caller
 already had a handle to the listener. However, for
-``qmp.listener(EventListener())`` forms, the caller will not have saved
-a handle to the listener.
+``qmp.listen(EventListener())`` forms, the caller will not have saved a
+handle to the listener.
 
 Because this function can accept *many* listeners, I found it hard to
 accurately type in a way where it could be used in both “one” or “many”
@@ -497,6 +516,21 @@ def __init__(
         #: Optional, secondary event filter.
         self.event_filter: Optional[EventFilter] = event_filter
 
+    def __repr__(self) -> str:
+        args: List[str] = []
+        if self.names:
+            args.append(f"names={self.names!r}")
+        if self.event_filter:
+            args.append(f"event_filter={self.event_filter!r}")
+
+        if self._queue.qsize():
+            state = f"<pending={self._queue.qsize()}>"
+        else:
+            state = ''
+
+        argstr = ", ".join(args)
+        return f"{type(self).__name__}{state}({argstr})"
+
     @property
     def history(self) -> Tuple[Message, ...]:
         """
@@ -618,7 +652,7 @@ class Events:
     def __init__(self) -> None:
         self._listeners: List[EventListener] = []
 
-        #: Default, all-events `EventListener`.
+        #: Default, all-events `EventListener`. See `qmp.events` for more info.
         self.events: EventListener = EventListener()
         self.register_listener(self.events)
 
diff --git a/python/qemu/qmp/legacy.py b/python/qemu/qmp/legacy.py
index 22a2b5616ef..9606e731864 100644
--- a/python/qemu/qmp/legacy.py
+++ b/python/qemu/qmp/legacy.py
@@ -86,7 +86,14 @@ def __init__(self,
                 "server argument should be False when passing a socket")
 
         self._qmp = QMPClient(nickname)
-        self._aloop = asyncio.get_event_loop()
+
+        try:
+            self._aloop = asyncio.get_running_loop()
+        except RuntimeError:
+            # No running loop; since this is a sync shim likely to be
+            # used in fully sync programs, create one if neccessary.
+            self._aloop = asyncio.get_event_loop_policy().get_event_loop()
+
         self._address = address
         self._timeout: Optional[float] = None
 
@@ -231,6 +238,9 @@ def pull_event(self,
 
         :return: The first available QMP event, or None.
         """
+        # Kick the event loop to allow events to accumulate
+        self._sync(asyncio.sleep(0))
+
         if not wait:
             # wait is False/0: "do not wait, do not except."
             if self._qmp.events.empty():
@@ -286,8 +296,8 @@ def settimeout(self, timeout: Optional[float]) -> None:
         """
         Set the timeout for QMP RPC execution.
 
-        This timeout affects the `cmd`, `cmd_obj`, and `command` methods.
-        The `accept`, `pull_event` and `get_event` methods have their
+        This timeout affects the `cmd`, `cmd_obj`, and `cmd_raw` methods.
+        The `accept`, `pull_event` and `get_events` methods have their
         own configurable timeouts.
 
         :param timeout:
diff --git a/python/qemu/qmp/message.py b/python/qemu/qmp/message.py
index f76ccc90746..dabb8ec360e 100644
--- a/python/qemu/qmp/message.py
+++ b/python/qemu/qmp/message.py
@@ -28,7 +28,8 @@ class Message(MutableMapping[str, object]):
     be instantiated from either another mapping (like a `dict`), or from
     raw `bytes` that still need to be deserialized.
 
-    Once instantiated, it may be treated like any other MutableMapping::
+    Once instantiated, it may be treated like any other
+    :py:obj:`~collections.abc.MutableMapping`::
 
         >>> msg = Message(b'{"hello": "world"}')
         >>> assert msg['hello'] == 'world'
@@ -50,12 +51,19 @@ class Message(MutableMapping[str, object]):
        >>> dict(msg)
        {'hello': 'world'}
 
+    Or pretty-printed::
+
+       >>> print(str(msg))
+       {
+         "hello": "world"
+       }
 
     :param value: Initial value, if any.
     :param eager:
         When `True`, attempt to serialize or deserialize the initial value
         immediately, so that conversion exceptions are raised during
         the call to ``__init__()``.
+
     """
     # pylint: disable=too-many-ancestors
 
@@ -178,15 +186,15 @@ class DeserializationError(ProtocolError):
     :param raw: The raw `bytes` that prompted the failure.
     """
     def __init__(self, error_message: str, raw: bytes):
-        super().__init__(error_message)
+        super().__init__(error_message, raw)
         #: The raw `bytes` that were not understood as JSON.
         self.raw: bytes = raw
 
     def __str__(self) -> str:
-        return "\n".join([
+        return "\n".join((
             super().__str__(),
             f"  raw bytes were: {str(self.raw)}",
-        ])
+        ))
 
 
 class UnexpectedTypeError(ProtocolError):
@@ -197,13 +205,13 @@ class UnexpectedTypeError(ProtocolError):
     :param value: The deserialized JSON value that wasn't an object.
     """
     def __init__(self, error_message: str, value: object):
-        super().__init__(error_message)
+        super().__init__(error_message, value)
         #: The JSON value that was expected to be an object.
         self.value: object = value
 
     def __str__(self) -> str:
         strval = json.dumps(self.value, indent=2)
-        return "\n".join([
+        return "\n".join((
             super().__str__(),
             f"  json value was: {strval}",
-        ])
+        ))
diff --git a/python/qemu/qmp/models.py b/python/qemu/qmp/models.py
index da52848d5a7..19dbe8781f4 100644
--- a/python/qemu/qmp/models.py
+++ b/python/qemu/qmp/models.py
@@ -54,7 +54,11 @@ def __repr__(self) -> str:
 
 class Greeting(Model):
     """
-    Defined in qmp-spec.rst, section "Server Greeting".
+    Defined in qmp-spec.rst, "Server Greeting".
+
+    See `2.2 Server Greeting
+    <https://gitlab.com/qemu-project/qemu/-/blob/master/docs/interop/qmp-spec.txt#L61>`_
+    for details.
 
     :param raw: The raw Greeting object.
     :raise KeyError: If any required fields are absent.
diff --git a/python/qemu/qmp/protocol.py b/python/qemu/qmp/protocol.py
index a4ffdfad51b..26486889d02 100644
--- a/python/qemu/qmp/protocol.py
+++ b/python/qemu/qmp/protocol.py
@@ -15,13 +15,16 @@
 
 import asyncio
 from asyncio import StreamReader, StreamWriter
+from contextlib import asynccontextmanager
 from enum import Enum
 from functools import wraps
+from inspect import iscoroutinefunction
 import logging
 import socket
 from ssl import SSLContext
 from typing import (
     Any,
+    AsyncGenerator,
     Awaitable,
     Callable,
     Generic,
@@ -36,13 +39,10 @@
 from .error import QMPError
 from .util import (
     bottom_half,
-    create_task,
     exception_summary,
     flush,
-    is_closing,
     pretty_traceback,
     upper_half,
-    wait_closed,
 )
 
 
@@ -76,11 +76,17 @@ class ConnectError(QMPError):
     This Exception always wraps a "root cause" exception that can be
     interrogated for additional information.
 
+    For example, when connecting to a non-existent socket::
+
+        await qmp.connect('not_found.sock')
+        # ConnectError: Failed to establish connection:
+        #               [Errno 2] No such file or directory
+
     :param error_message: Human-readable string describing the error.
     :param exc: The root-cause exception.
     """
     def __init__(self, error_message: str, exc: Exception):
-        super().__init__(error_message)
+        super().__init__(error_message, exc)
         #: Human-readable error string
         self.error_message: str = error_message
         #: Wrapped root cause exception
@@ -99,8 +105,8 @@ class StateError(QMPError):
     An API command (connect, execute, etc) was issued at an inappropriate time.
 
     This error is raised when a command like
-    :py:meth:`~AsyncProtocol.connect()` is issued at an inappropriate
-    time.
+    :py:meth:`~AsyncProtocol.connect()` is called when the client is
+    already connected.
 
     :param error_message: Human-readable string describing the state violation.
     :param state: The actual `Runstate` seen at the time of the violation.
@@ -108,11 +114,14 @@ class StateError(QMPError):
     """
     def __init__(self, error_message: str,
                  state: Runstate, required: Runstate):
-        super().__init__(error_message)
+        super().__init__(error_message, state, required)
         self.error_message = error_message
         self.state = state
         self.required = required
 
+    def __str__(self) -> str:
+        return self.error_message
+
 
 F = TypeVar('F', bound=Callable[..., Any])  # pylint: disable=invalid-name
 
@@ -125,6 +134,25 @@ def require(required_state: Runstate) -> Callable[[F], F]:
     :param required_state: The `Runstate` required to invoke this method.
     :raise StateError: When the required `Runstate` is not met.
     """
+    def _check(proto: 'AsyncProtocol[Any]') -> None:
+        name = type(proto).__name__
+        if proto.runstate == required_state:
+            return
+
+        if proto.runstate == Runstate.CONNECTING:
+            emsg = f"{name} is currently connecting."
+        elif proto.runstate == Runstate.DISCONNECTING:
+            emsg = (f"{name} is disconnecting."
+                    " Call disconnect() to return to IDLE state.")
+        elif proto.runstate == Runstate.RUNNING:
+            emsg = f"{name} is already connected and running."
+        elif proto.runstate == Runstate.IDLE:
+            emsg = f"{name} is disconnected and idle."
+        else:
+            assert False
+
+        raise StateError(emsg, proto.runstate, required_state)
+
     def _decorator(func: F) -> F:
         # _decorator is the decorator that is built by calling the
         # require() decorator factory; e.g.:
@@ -135,29 +163,20 @@ def _decorator(func: F) -> F:
         @wraps(func)
         def _wrapper(proto: 'AsyncProtocol[Any]',
                      *args: Any, **kwargs: Any) -> Any:
-            # _wrapper is the function that gets executed prior to the
-            # decorated method.
-
-            name = type(proto).__name__
-
-            if proto.runstate != required_state:
-                if proto.runstate == Runstate.CONNECTING:
-                    emsg = f"{name} is currently connecting."
-                elif proto.runstate == Runstate.DISCONNECTING:
-                    emsg = (f"{name} is disconnecting."
-                            " Call disconnect() to return to IDLE state.")
-                elif proto.runstate == Runstate.RUNNING:
-                    emsg = f"{name} is already connected and running."
-                elif proto.runstate == Runstate.IDLE:
-                    emsg = f"{name} is disconnected and idle."
-                else:
-                    assert False
-                raise StateError(emsg, proto.runstate, required_state)
-            # No StateError, so call the wrapped method.
+            _check(proto)
             return func(proto, *args, **kwargs)
 
-        # Return the decorated method;
-        # Transforming Func to Decorated[Func].
+        @wraps(func)
+        async def _async_wrapper(proto: 'AsyncProtocol[Any]',
+                                 *args: Any, **kwargs: Any) -> Any:
+            _check(proto)
+            return await func(proto, *args, **kwargs)
+
+        # Return the decorated method; F => Decorated[F]
+        # Use an async version when applicable, which
+        # preserves async signature generation in sphinx.
+        if iscoroutinefunction(func):
+            return cast(F, _async_wrapper)
         return cast(F, _wrapper)
 
     # Return the decorator instance from the decorator factory. Phew!
@@ -214,10 +233,8 @@ class AsyncProtocol(Generic[T]):
     # -------------------------
 
     def __init__(self, name: Optional[str] = None) -> None:
-        #: The nickname for this connection, if any.
-        self.name: Optional[str] = name
-        if self.name is not None:
-            self.logger = self.logger.getChild(self.name)
+        self._name: Optional[str]
+        self.name = name
 
         # stream I/O
         self._reader: Optional[StreamReader] = None
@@ -254,6 +271,24 @@ def __repr__(self) -> str:
         tokens.append(f"runstate={self.runstate.name}")
         return f"<{cls_name} {' '.join(tokens)}>"
 
+    @property
+    def name(self) -> Optional[str]:
+        """
+        The nickname for this connection, if any.
+
+        This name is used for differentiating instances in debug output.
+        """
+        return self._name
+
+    @name.setter
+    def name(self, name: Optional[str]) -> None:
+        logger = logging.getLogger(__name__)
+        if name:
+            self.logger = logger.getChild(name)
+        else:
+            self.logger = logger
+        self._name = name
+
     @property  # @upper_half
     def runstate(self) -> Runstate:
         """The current `Runstate` of the connection."""
@@ -262,7 +297,7 @@ def runstate(self) -> Runstate:
     @upper_half
     async def runstate_changed(self) -> Runstate:
         """
-        Wait for the `runstate` to change, then return that runstate.
+        Wait for the `runstate` to change, then return that `Runstate`.
         """
         await self._runstate_event.wait()
         return self.runstate
@@ -276,9 +311,9 @@ async def start_server_and_accept(
         """
         Accept a connection and begin processing message queues.
 
-        If this call fails, `runstate` is guaranteed to be set back to `IDLE`.
-        This method is precisely equivalent to calling `start_server()`
-        followed by `accept()`.
+        If this call fails, `runstate` is guaranteed to be set back to
+        `IDLE`.  This method is precisely equivalent to calling
+        `start_server()` followed by :py:meth:`~AsyncProtocol.accept()`.
 
         :param address:
             Address to listen on; UNIX socket path or TCP address/port.
@@ -291,7 +326,8 @@ async def start_server_and_accept(
             This exception will wrap a more concrete one. In most cases,
             the wrapped exception will be `OSError` or `EOFError`. If a
             protocol-level failure occurs while establishing a new
-            session, the wrapped error may also be an `QMPError`.
+            session, the wrapped error may also be a `QMPError`.
+
         """
         await self.start_server(address, ssl)
         await self.accept()
@@ -307,8 +343,8 @@ async def start_server(self, address: SocketAddrT,
         This method starts listening for an incoming connection, but
         does not block waiting for a peer. This call will return
         immediately after binding and listening on a socket. A later
-        call to `accept()` must be made in order to finalize the
-        incoming connection.
+        call to :py:meth:`~AsyncProtocol.accept()` must be made in order
+        to finalize the incoming connection.
 
         :param address:
             Address to listen on; UNIX socket path or TCP address/port.
@@ -321,9 +357,8 @@ async def start_server(self, address: SocketAddrT,
             This exception will wrap a more concrete one. In most cases,
             the wrapped exception will be `OSError`.
         """
-        await self._session_guard(
-            self._do_start_server(address, ssl),
-            'Failed to establish connection')
+        async with self._session_guard('Failed to establish connection'):
+            await self._do_start_server(address, ssl)
         assert self.runstate == Runstate.CONNECTING
 
     @upper_half
@@ -332,10 +367,12 @@ async def accept(self) -> None:
         """
         Accept an incoming connection and begin processing message queues.
 
-        If this call fails, `runstate` is guaranteed to be set back to `IDLE`.
+        Used after a previous call to `start_server()` to accept an
+        incoming connection. If this call fails, `runstate` is
+        guaranteed to be set back to `IDLE`.
 
         :raise StateError: When the `Runstate` is not `CONNECTING`.
-        :raise QMPError: When `start_server()` was not called yet.
+        :raise QMPError: When `start_server()` was not called first.
         :raise ConnectError:
             When a connection or session cannot be established.
 
@@ -346,12 +383,10 @@ async def accept(self) -> None:
         """
         if self._accepted is None:
             raise QMPError("Cannot call accept() before start_server().")
-        await self._session_guard(
-            self._do_accept(),
-            'Failed to establish connection')
-        await self._session_guard(
-            self._establish_session(),
-            'Failed to establish session')
+        async with self._session_guard('Failed to establish connection'):
+            await self._do_accept()
+        async with self._session_guard('Failed to establish session'):
+            await self._establish_session()
         assert self.runstate == Runstate.RUNNING
 
     @upper_half
@@ -376,12 +411,10 @@ async def connect(self, address: Union[SocketAddrT, socket.socket],
             protocol-level failure occurs while establishing a new
             session, the wrapped error may also be an `QMPError`.
         """
-        await self._session_guard(
-            self._do_connect(address, ssl),
-            'Failed to establish connection')
-        await self._session_guard(
-            self._establish_session(),
-            'Failed to establish session')
+        async with self._session_guard('Failed to establish connection'):
+            await self._do_connect(address, ssl)
+        async with self._session_guard('Failed to establish session'):
+            await self._establish_session()
         assert self.runstate == Runstate.RUNNING
 
     @upper_half
@@ -392,7 +425,11 @@ async def disconnect(self) -> None:
         If there was an exception that caused the reader/writers to
         terminate prematurely, it will be raised here.
 
-        :raise Exception: When the reader or writer terminate unexpectedly.
+        :raise Exception:
+            When the reader or writer terminate unexpectedly. You can
+            expect to see `EOFError` if the server hangs up, or
+            `OSError` for connection-related issues. If there was a QMP
+            protocol-level problem, `ProtocolError` will be seen.
         """
         self.logger.debug("disconnect() called.")
         self._schedule_disconnect()
@@ -402,7 +439,8 @@ async def disconnect(self) -> None:
     # Section: Session machinery
     # --------------------------
 
-    async def _session_guard(self, coro: Awaitable[None], emsg: str) -> None:
+    @asynccontextmanager
+    async def _session_guard(self, emsg: str) -> AsyncGenerator[None, None]:
         """
         Async guard function used to roll back to `IDLE` on any error.
 
@@ -419,10 +457,9 @@ async def _session_guard(self, coro: Awaitable[None], emsg: str) -> None:
         :raise ConnectError:
             When any other error is encountered in the guarded block.
         """
-        # Note: After Python 3.6 support is removed, this should be an
-        # @asynccontextmanager instead of accepting a callback.
         try:
-            await coro
+            # Caller's code runs here.
+            yield
         except BaseException as err:
             self.logger.error("%s: %s", emsg, exception_summary(err))
             self.logger.debug("%s:\n%s\n", emsg, pretty_traceback())
@@ -663,8 +700,8 @@ async def _establish_session(self) -> None:
         reader_coro = self._bh_loop_forever(self._bh_recv_message, 'Reader')
         writer_coro = self._bh_loop_forever(self._bh_send_message, 'Writer')
 
-        self._reader_task = create_task(reader_coro)
-        self._writer_task = create_task(writer_coro)
+        self._reader_task = asyncio.create_task(reader_coro)
+        self._writer_task = asyncio.create_task(writer_coro)
 
         self._bh_tasks = asyncio.gather(
             self._reader_task,
@@ -689,7 +726,7 @@ def _schedule_disconnect(self) -> None:
         if not self._dc_task:
             self._set_state(Runstate.DISCONNECTING)
             self.logger.debug("Scheduling disconnect.")
-            self._dc_task = create_task(self._bh_disconnect())
+            self._dc_task = asyncio.create_task(self._bh_disconnect())
 
     @upper_half
     async def _wait_disconnect(self) -> None:
@@ -825,13 +862,13 @@ async def _bh_close_stream(self, error_pathway: bool = False) -> None:
         if not self._writer:
             return
 
-        if not is_closing(self._writer):
+        if not self._writer.is_closing():
             self.logger.debug("Closing StreamWriter.")
             self._writer.close()
 
         self.logger.debug("Waiting for StreamWriter to close ...")
         try:
-            await wait_closed(self._writer)
+            await self._writer.wait_closed()
         except Exception:  # pylint: disable=broad-except
             # It's hard to tell if the Stream is already closed or
             # not. Even if one of the tasks has failed, it may have
diff --git a/python/qemu/qmp/qmp_client.py b/python/qemu/qmp/qmp_client.py
index 2a817f9db33..55508ff73f3 100644
--- a/python/qemu/qmp/qmp_client.py
+++ b/python/qemu/qmp/qmp_client.py
@@ -41,7 +41,7 @@ class _WrappedProtocolError(ProtocolError):
     :param exc: The root-cause exception.
     """
     def __init__(self, error_message: str, exc: Exception):
-        super().__init__(error_message)
+        super().__init__(error_message, exc)
         self.exc = exc
 
     def __str__(self) -> str:
@@ -70,21 +70,38 @@ class ExecuteError(QMPError):
     """
     Exception raised by `QMPClient.execute()` on RPC failure.
 
+    This exception is raised when the server received, interpreted, and
+    replied to a command successfully; but the command itself returned a
+    failure status.
+
+    For example::
+
+        await qmp.execute('block-dirty-bitmap-add',
+                          {'node': 'foo', 'name': 'my_bitmap'})
+        # qemu.qmp.qmp_client.ExecuteError:
+        #     Cannot find device='foo' nor node-name='foo'
+
     :param error_response: The RPC error response object.
     :param sent: The sent RPC message that caused the failure.
     :param received: The raw RPC error reply received.
     """
     def __init__(self, error_response: ErrorResponse,
                  sent: Message, received: Message):
-        super().__init__(error_response.error.desc)
+        super().__init__(error_response, sent, received)
         #: The sent `Message` that caused the failure
         self.sent: Message = sent
         #: The received `Message` that indicated failure
         self.received: Message = received
         #: The parsed error response
         self.error: ErrorResponse = error_response
-        #: The QMP error class
-        self.error_class: str = error_response.error.class_
+
+    @property
+    def error_class(self) -> str:
+        """The QMP error class"""
+        return self.error.error.class_
+
+    def __str__(self) -> str:
+        return self.error.error.desc
 
 
 class ExecInterruptedError(QMPError):
@@ -93,9 +110,22 @@ class ExecInterruptedError(QMPError):
 
     This error is raised when an `execute()` statement could not be
     completed.  This can occur because the connection itself was
-    terminated before a reply was received.
+    terminated before a reply was received. The true cause of the
+    interruption will be available via `disconnect()`.
 
-    The true cause of the interruption will be available via `disconnect()`.
+    The QMP protocol does not make it possible to know if a command
+    succeeded or failed after such an event; the client will need to
+    query the server to determine the state of the server on a
+    case-by-case basis.
+
+    For example, ECONNRESET might look like this::
+
+        try:
+            await qmp.execute('query-block')
+            # ExecInterruptedError: Disconnected
+        except ExecInterruptedError:
+            await qmp.disconnect()
+            # ConnectionResetError: [Errno 104] Connection reset by peer
     """
 
 
@@ -110,8 +140,8 @@ class _MsgProtocolError(ProtocolError):
     :param error_message: Human-readable string describing the error.
     :param msg: The QMP `Message` that caused the error.
     """
-    def __init__(self, error_message: str, msg: Message):
-        super().__init__(error_message)
+    def __init__(self, error_message: str, msg: Message, *args: object):
+        super().__init__(error_message, msg, *args)
         #: The received `Message` that caused the error.
         self.msg: Message = msg
 
@@ -150,30 +180,38 @@ class BadReplyError(_MsgProtocolError):
     :param sent: The message that was sent that prompted the error.
     """
     def __init__(self, error_message: str, msg: Message, sent: Message):
-        super().__init__(error_message, msg)
+        super().__init__(error_message, msg, sent)
         #: The sent `Message` that caused the failure
         self.sent = sent
 
 
 class QMPClient(AsyncProtocol[Message], Events):
-    """
-    Implements a QMP client connection.
+    """Implements a QMP client connection.
 
-    QMP can be used to establish a connection as either the transport
-    client or server, though this class always acts as the QMP client.
+    `QMPClient` can be used to either connect or listen to a QMP server,
+    but always acts as the QMP client.
 
-    :param name: Optional nickname for the connection, used for logging.
+    :param name:
+        Optional nickname for the connection, used to differentiate
+        instances when logging.
 
     Basic script-style usage looks like this::
 
-      qmp = QMPClient('my_virtual_machine_name')
-      await qmp.connect(('127.0.0.1', 1234))
-      ...
-      res = await qmp.execute('block-query')
-      ...
-      await qmp.disconnect()
+      import asyncio
+      from qemu.qmp import QMPClient
 
-    Basic async client-style usage looks like this::
+      async def main():
+          qmp = QMPClient('my_virtual_machine_name')
+          await qmp.connect(('127.0.0.1', 1234))
+          ...
+          res = await qmp.execute('query-block')
+          ...
+          await qmp.disconnect()
+
+      asyncio.run(main())
+
+    A more advanced example that starts to take advantage of asyncio
+    might look like this::
 
       class Client:
           def __init__(self, name: str):
@@ -193,6 +231,7 @@ async def run(self, address='/tmp/qemu.socket'):
               await self.disconnect()
 
     See `qmp.events` for more detail on event handling patterns.
+
     """
     #: Logger object used for debugging messages.
     logger = logging.getLogger(__name__)
@@ -208,10 +247,12 @@ def __init__(self, name: Optional[str] = None) -> None:
         Events.__init__(self)
 
         #: Whether or not to await a greeting after establishing a connection.
+        #: Defaults to True; QGA servers expect this to be False.
         self.await_greeting: bool = True
 
-        #: Whether or not to perform capabilities negotiation upon connection.
-        #: Implies `await_greeting`.
+        #: Whether or not to perform capabilities negotiation upon
+        #: connection. Implies `await_greeting`. Defaults to True; QGA
+        #: servers expect this to be False.
         self.negotiate: bool = True
 
         # Cached Greeting, if one was awaited.
@@ -228,7 +269,13 @@ def __init__(self, name: Optional[str] = None) -> None:
 
     @property
     def greeting(self) -> Optional[Greeting]:
-        """The `Greeting` from the QMP server, if any."""
+        """
+        The `Greeting` from the QMP server, if any.
+
+        Defaults to ``None``, and will be set after a greeting is
+        received during the connection process. It is reset at the start
+        of each connection attempt.
+        """
         return self._greeting
 
     @upper_half
@@ -550,7 +597,7 @@ async def _raw(
     @require(Runstate.RUNNING)
     async def execute_msg(self, msg: Message) -> object:
         """
-        Execute a QMP command and return its value.
+        Execute a QMP command on the server and return its value.
 
         :param msg: The QMP `Message` to execute.
 
@@ -562,7 +609,9 @@ async def execute_msg(self, msg: Message) -> object:
             If the QMP `Message` does not have either the 'execute' or
             'exec-oob' fields set.
         :raise ExecuteError: When the server returns an error response.
-        :raise ExecInterruptedError: if the connection was terminated early.
+        :raise ExecInterruptedError:
+            If the connection was disrupted before
+            receiving a reply from the server.
         """
         if not ('execute' in msg or 'exec-oob' in msg):
             raise ValueError("Requires 'execute' or 'exec-oob' message")
@@ -601,9 +650,11 @@ def make_execute_msg(cls, cmd: str,
 
         :param cmd: QMP command name.
         :param arguments: Arguments (if any). Must be JSON-serializable.
-        :param oob: If `True`, execute "out of band".
+        :param oob:
+            If `True`, execute `"out of band"
+            <https://gitlab.com/qemu-project/qemu/-/blob/master/docs/interop/qmp-spec.txt#L116>`_.
 
-        :return: An executable QMP `Message`.
+        :return: A QMP `Message` that can be executed with `execute_msg()`.
         """
         msg = Message({'exec-oob' if oob else 'execute': cmd})
         if arguments is not None:
@@ -615,18 +666,22 @@ async def execute(self, cmd: str,
                       arguments: Optional[Mapping[str, object]] = None,
                       oob: bool = False) -> object:
         """
-        Execute a QMP command and return its value.
+        Execute a QMP command on the server and return its value.
 
         :param cmd: QMP command name.
         :param arguments: Arguments (if any). Must be JSON-serializable.
-        :param oob: If `True`, execute "out of band".
+        :param oob:
+            If `True`, execute `"out of band"
+            <https://gitlab.com/qemu-project/qemu/-/blob/master/docs/interop/qmp-spec.txt#L116>`_.
 
         :return:
             The command execution return value from the server. The type of
             object returned depends on the command that was issued,
             though most in QEMU return a `dict`.
         :raise ExecuteError: When the server returns an error response.
-        :raise ExecInterruptedError: if the connection was terminated early.
+        :raise ExecInterruptedError:
+            If the connection was disrupted before
+            receiving a reply from the server.
         """
         msg = self.make_execute_msg(cmd, arguments, oob=oob)
         return await self.execute_msg(msg)
@@ -634,8 +689,20 @@ async def execute(self, cmd: str,
     @upper_half
     @require(Runstate.RUNNING)
     def send_fd_scm(self, fd: int) -> None:
-        """
-        Send a file descriptor to the remote via SCM_RIGHTS.
+        """Send a file descriptor to the remote via SCM_RIGHTS.
+
+        This method does not close the file descriptor.
+
+        :param fd: The file descriptor to send to QEMU.
+
+        This is an advanced feature of QEMU where file descriptors can
+        be passed from client to server. This is usually used as a
+        security measure to isolate the QEMU process from being able to
+        open its own files. See the QMP commands ``getfd`` and
+        ``add-fd`` for more information.
+
+        See `socket.socket.sendmsg` for more information on the Python
+        implementation for sending file descriptors over a UNIX socket.
         """
         assert self._writer is not None
         sock = self._writer.transport.get_extra_info('socket')
diff --git a/python/qemu/qmp/qmp_shell.py b/python/qemu/qmp/qmp_shell.py
index 98e684e9e8a..c39ba4be165 100644
--- a/python/qemu/qmp/qmp_shell.py
+++ b/python/qemu/qmp/qmp_shell.py
@@ -10,9 +10,15 @@
 #
 
 """
-Low-level QEMU shell on top of QMP.
+qmp-shell - An interactive QEMU shell powered by QMP
 
-usage: qmp-shell [-h] [-H] [-N] [-v] [-p] qmp_server
+qmp-shell offers a simple shell with a convenient shorthand syntax as an
+alternative to typing JSON by hand. This syntax is not standardized and
+is not meant to be used as a scriptable interface. This shorthand *may*
+change incompatibly in the future, and it is strongly encouraged to use
+the QMP library to provide API-stable scripting when needed.
+
+usage: qmp-shell [-h] [-H] [-v] [-p] [-l LOGFILE] [-N] qmp_server
 
 positional arguments:
   qmp_server            < UNIX socket path | TCP address:port >
@@ -20,41 +26,52 @@
 optional arguments:
   -h, --help            show this help message and exit
   -H, --hmp             Use HMP interface
-  -N, --skip-negotiation
-                        Skip negotiate (for qemu-ga)
   -v, --verbose         Verbose (echo commands sent and received)
   -p, --pretty          Pretty-print JSON
+  -l LOGFILE, --logfile LOGFILE
+                        Save log of all QMP messages to PATH
+  -N, --skip-negotiation
+                        Skip negotiate (for qemu-ga)
 
+Usage
+-----
 
-Start QEMU with:
+First, start QEMU with::
 
-# qemu [...] -qmp unix:./qmp-sock,server
+    > qemu [...] -qmp unix:./qmp-sock,server=on[,wait=off]
 
-Run the shell:
+Then run the shell, passing the address of the socket::
 
-$ qmp-shell ./qmp-sock
+    > qmp-shell ./qmp-sock
 
-Commands have the following format:
+Syntax
+------
 
-   < command-name > [ arg-name1=arg1 ] ... [ arg-nameN=argN ]
+Commands have the following format::
 
-For example:
+    < command-name > [ arg-name1=arg1 ] ... [ arg-nameN=argN ]
 
-(QEMU) device_add driver=e1000 id=net1
-{'return': {}}
-(QEMU)
+For example, to add a network device::
 
-key=value pairs also support Python or JSON object literal subset notations,
-without spaces. Dictionaries/objects {} are supported as are arrays [].
+    (QEMU) device_add driver=e1000 id=net1
+    {'return': {}}
+    (QEMU)
 
-   example-command arg-name1={'key':'value','obj'={'prop':"value"}}
+key=value pairs support either Python or JSON object literal notations,
+**without spaces**. Dictionaries/objects ``{}`` are supported, as are
+arrays ``[]``::
 
-Both JSON and Python formatting should work, including both styles of
-string literal quotes. Both paradigms of literal values should work,
-including null/true/false for JSON and None/True/False for Python.
+    example-command arg-name1={'key':'value','obj'={'prop':"value"}}
 
+Either JSON or Python formatting for compound values works, including
+both styles of string literal quotes (either single or double
+quotes). Both paradigms of literal values are accepted, including
+``null/true/false`` for JSON and ``None/True/False`` for Python.
 
-Transactions have the following multi-line format:
+Transactions
+------------
+
+Transactions have the following multi-line format::
 
    transaction(
    action-name1 [ arg-name1=arg1 ] ... [arg-nameN=argN ]
@@ -62,11 +79,11 @@
    action-nameN [ arg-name1=arg1 ] ... [arg-nameN=argN ]
    )
 
-One line transactions are also supported:
+One line transactions are also supported::
 
    transaction( action-name1 ... )
 
-For example:
+For example::
 
     (QEMU) transaction(
     TRANS> block-dirty-bitmap-add node=drive0 name=bitmap1
@@ -75,9 +92,35 @@
     {"return": {}}
     (QEMU)
 
-Use the -v and -p options to activate the verbose and pretty-print options,
-which will echo back the properly formatted JSON-compliant QMP that is being
-sent to QEMU, which is useful for debugging and documentation generation.
+Commands
+--------
+
+Autocomplete of command names using <tab> is supported. Pressing <tab>
+at a blank CLI prompt will show you a list of all available commands
+that the connected QEMU instance supports.
+
+For documentation on QMP commands and their arguments, please see
+`qmp ref`.
+
+Events
+------
+
+qmp-shell will display events received from the server, but this version
+does not do so asynchronously. To check for new events from the server,
+press <enter> on a blank line::
+
+    (QEMU) ⏎
+    {'timestamp': {'seconds': 1660071944, 'microseconds': 184667},
+     'event': 'STOP'}
+
+Display options
+---------------
+
+Use the -v and -p options to activate the verbose and pretty-print
+options, which will echo back the properly formatted JSON-compliant QMP
+that is being sent to QEMU. This is useful for debugging to see the
+wire-level QMP data being exchanged, and generating output for use in
+writing documentation for QEMU.
 """
 
 import argparse
@@ -181,6 +224,7 @@ def __init__(self, address: SocketAddrT,
                  verbose: bool = False,
                  server: bool = False,
                  logfile: Optional[str] = None):
+        # pylint: disable=too-many-positional-arguments
         super().__init__(address, server=server)
         self._greeting: Optional[QMPMessage] = None
         self._completer = QMPCompleter()
@@ -434,6 +478,7 @@ def __init__(self, address: SocketAddrT,
                  verbose: bool = False,
                  server: bool = False,
                  logfile: Optional[str] = None):
+        # pylint: disable=too-many-positional-arguments
         super().__init__(address, pretty, verbose, server, logfile)
         self._cpu_index = 0
 
@@ -514,21 +559,29 @@ def die(msg: str) -> NoReturn:
     sys.exit(1)
 
 
+def common_parser() -> argparse.ArgumentParser:
+    """Build common parsing options used by qmp-shell and qmp-shell-wrap."""
+    parser = argparse.ArgumentParser()
+    parser.add_argument('-H', '--hmp', action='store_true',
+                        help='Use HMP interface')
+    parser.add_argument('-v', '--verbose', action='store_true',
+                        help='Verbose (echo commands sent and received)')
+    parser.add_argument('-p', '--pretty', action='store_true',
+                        help='Pretty-print JSON')
+    parser.add_argument('-l', '--logfile',
+                        help='Save log of all QMP messages to PATH')
+    # NOTE: When changing arguments, update both this module docstring
+    # and the manpage synopsis in docs/man/qmp_shell.rst.
+    return parser
+
+
 def main() -> None:
     """
     qmp-shell entry point: parse command line arguments and start the REPL.
     """
-    parser = argparse.ArgumentParser()
-    parser.add_argument('-H', '--hmp', action='store_true',
-                        help='Use HMP interface')
+    parser = common_parser()
     parser.add_argument('-N', '--skip-negotiation', action='store_true',
                         help='Skip negotiate (for qemu-ga)')
-    parser.add_argument('-v', '--verbose', action='store_true',
-                        help='Verbose (echo commands sent and received)')
-    parser.add_argument('-p', '--pretty', action='store_true',
-                        help='Pretty-print JSON')
-    parser.add_argument('-l', '--logfile',
-                        help='Save log of all QMP messages to PATH')
 
     default_server = os.environ.get('QMP_SOCKET')
     parser.add_argument('qmp_server', action='store',
@@ -561,19 +614,37 @@ def main() -> None:
 
 def main_wrap() -> None:
     """
-    qmp-shell-wrap entry point: parse command line arguments and
-    start the REPL.
+    qmp-shell-wrap - QEMU + qmp-shell launcher utility
+
+    Launch QEMU and connect to it with `qmp-shell` in a single command.
+    CLI arguments will be forwarded to qemu, with additional arguments
+    added to allow `qmp-shell` to then connect to the recently launched
+    QEMU instance.
+
+    usage: qmp-shell-wrap [-h] [-H] [-v] [-p] [-l LOGFILE] ...
+
+    positional arguments:
+      command               QEMU command line to invoke
+
+    optional arguments:
+      -h, --help            show this help message and exit
+      -H, --hmp             Use HMP interface
+      -v, --verbose         Verbose (echo commands sent and received)
+      -p, --pretty          Pretty-print JSON
+      -l LOGFILE, --logfile LOGFILE
+                            Save log of all QMP messages to PATH
+
+    Usage
+    -----
+
+    Prepend "qmp-shell-wrap" to your usual QEMU command line::
+
+        > qmp-shell-wrap qemu-system-x86_64 -M q35 -m 4096 -display none
+        Welcome to the QMP low-level shell!
+        Connected
+        (QEMU)
     """
-    parser = argparse.ArgumentParser()
-    parser.add_argument('-H', '--hmp', action='store_true',
-                        help='Use HMP interface')
-    parser.add_argument('-v', '--verbose', action='store_true',
-                        help='Verbose (echo commands sent and received)')
-    parser.add_argument('-p', '--pretty', action='store_true',
-                        help='Pretty-print JSON')
-    parser.add_argument('-l', '--logfile',
-                        help='Save log of all QMP messages to PATH')
-
+    parser = common_parser()
     parser.add_argument('command', nargs=argparse.REMAINDER,
                         help='QEMU command line to invoke')
 
@@ -610,6 +681,8 @@ def main_wrap() -> None:
 
                 for _ in qemu.repl():
                     pass
+    except FileNotFoundError:
+        sys.stderr.write(f"ERROR: QEMU executable '{cmd[0]}' not found.\n")
     finally:
         os.unlink(sockpath)
 
diff --git a/python/qemu/qmp/qmp_tui.py b/python/qemu/qmp/qmp_tui.py
index 2d9ebbd20bc..12bdc17c99e 100644
--- a/python/qemu/qmp/qmp_tui.py
+++ b/python/qemu/qmp/qmp_tui.py
@@ -21,6 +21,7 @@
 import logging
 from logging import Handler, LogRecord
 import signal
+import sys
 from typing import (
     List,
     Optional,
@@ -30,17 +31,27 @@
     cast,
 )
 
-from pygments import lexers
-from pygments import token as Token
-import urwid
-import urwid_readline
+
+try:
+    from pygments import lexers
+    from pygments import token as Token
+    import urwid
+    import urwid_readline
+except ModuleNotFoundError as exc:
+    print(
+        f"Module '{exc.name}' not found.",
+        "You need the optional 'tui' group: pip install qemu.qmp[tui]",
+        sep='\n',
+        file=sys.stderr,
+    )
+    sys.exit(1)
 
 from .error import ProtocolError
 from .legacy import QEMUMonitorProtocol, QMPBadPortError
 from .message import DeserializationError, Message, UnexpectedTypeError
 from .protocol import ConnectError, Runstate
 from .qmp_client import ExecInterruptedError, QMPClient
-from .util import create_task, pretty_traceback
+from .util import pretty_traceback
 
 
 # The name of the signal that is used to update the history list
@@ -225,7 +236,7 @@ def cb_send_to_server(self, raw_msg: str) -> None:
         """
         try:
             msg = Message(bytes(raw_msg, encoding='utf-8'))
-            create_task(self._send_to_server(msg))
+            asyncio.create_task(self._send_to_server(msg))
         except (DeserializationError, UnexpectedTypeError) as err:
             raw_msg = format_json(raw_msg)
             logging.info('Invalid message: %s', err.error_message)
@@ -246,7 +257,7 @@ def kill_app(self) -> None:
         Initiates killing of app. A bridge between asynchronous and synchronous
         code.
         """
-        create_task(self._kill_app())
+        asyncio.create_task(self._kill_app())
 
     async def _kill_app(self) -> None:
         """
@@ -377,7 +388,12 @@ def run(self, debug: bool = False) -> None:
         screen = urwid.raw_display.Screen()
         screen.set_terminal_properties(256)
 
-        self.aloop = asyncio.get_event_loop()
+        try:
+            self.aloop = asyncio.get_running_loop()
+        except RuntimeError:
+            # No running asyncio event loop. Create one if necessary.
+            self.aloop = asyncio.get_event_loop_policy().get_event_loop()
+
         self.aloop.set_debug(debug)
 
         # Gracefully handle SIGTERM and SIGINT signals
@@ -393,7 +409,7 @@ def run(self, debug: bool = False) -> None:
                                    handle_mouse=True,
                                    event_loop=event_loop)
 
-        create_task(self.manage_connection(), self.aloop)
+        self.aloop.create_task(self.manage_connection())
         try:
             main_loop.run()
         except Exception as err:
diff --git a/python/qemu/qmp/util.py b/python/qemu/qmp/util.py
index ca6225e9cda..e73d06e70ef 100644
--- a/python/qemu/qmp/util.py
+++ b/python/qemu/qmp/util.py
@@ -1,25 +1,15 @@
 """
 Miscellaneous Utilities
 
-This module provides asyncio utilities and compatibility wrappers for
-Python 3.6 to provide some features that otherwise become available in
-Python 3.7+.
-
-Various logging and debugging utilities are also provided, such as
-`exception_summary()` and `pretty_traceback()`, used primarily for
-adding information into the logging stream.
+This module provides asyncio and various logging and debugging
+utilities, such as `exception_summary()` and `pretty_traceback()`, used
+primarily for adding information into the logging stream.
 """
 
 import asyncio
 import sys
 import traceback
-from typing import (
-    Any,
-    Coroutine,
-    Optional,
-    TypeVar,
-    cast,
-)
+from typing import TypeVar, cast
 
 
 T = TypeVar('T')
@@ -32,7 +22,7 @@
 
 async def flush(writer: asyncio.StreamWriter) -> None:
     """
-    Utility function to ensure a StreamWriter is *fully* drained.
+    Utility function to ensure an `asyncio.StreamWriter` is *fully* drained.
 
     `asyncio.StreamWriter.drain` only promises we will return to below
     the "high-water mark". This function ensures we flush the entire
@@ -72,102 +62,13 @@ def bottom_half(func: T) -> T:
 
     These methods do not, in general, have the ability to directly
     report information to a caller’s context and will usually be
-    collected as a Task result instead.
+    collected as an `asyncio.Task` result instead.
 
     They must not call upper-half functions directly.
     """
     return func
 
 
-# -------------------------------
-# Section: Compatibility Wrappers
-# -------------------------------
-
-
-def create_task(coro: Coroutine[Any, Any, T],
-                loop: Optional[asyncio.AbstractEventLoop] = None
-                ) -> 'asyncio.Future[T]':
-    """
-    Python 3.6-compatible `asyncio.create_task` wrapper.
-
-    :param coro: The coroutine to execute in a task.
-    :param loop: Optionally, the loop to create the task in.
-
-    :return: An `asyncio.Future` object.
-    """
-    if sys.version_info >= (3, 7):
-        if loop is not None:
-            return loop.create_task(coro)
-        return asyncio.create_task(coro)  # pylint: disable=no-member
-
-    # Python 3.6:
-    return asyncio.ensure_future(coro, loop=loop)
-
-
-def is_closing(writer: asyncio.StreamWriter) -> bool:
-    """
-    Python 3.6-compatible `asyncio.StreamWriter.is_closing` wrapper.
-
-    :param writer: The `asyncio.StreamWriter` object.
-    :return: `True` if the writer is closing, or closed.
-    """
-    if sys.version_info >= (3, 7):
-        return writer.is_closing()
-
-    # Python 3.6:
-    transport = writer.transport
-    assert isinstance(transport, asyncio.WriteTransport)
-    return transport.is_closing()
-
-
-async def wait_closed(writer: asyncio.StreamWriter) -> None:
-    """
-    Python 3.6-compatible `asyncio.StreamWriter.wait_closed` wrapper.
-
-    :param writer: The `asyncio.StreamWriter` to wait on.
-    """
-    if sys.version_info >= (3, 7):
-        await writer.wait_closed()
-        return
-
-    # Python 3.6
-    transport = writer.transport
-    assert isinstance(transport, asyncio.WriteTransport)
-
-    while not transport.is_closing():
-        await asyncio.sleep(0)
-
-    # This is an ugly workaround, but it's the best I can come up with.
-    sock = transport.get_extra_info('socket')
-
-    if sock is None:
-        # Our transport doesn't have a socket? ...
-        # Nothing we can reasonably do.
-        return
-
-    while sock.fileno() != -1:
-        await asyncio.sleep(0)
-
-
-def asyncio_run(coro: Coroutine[Any, Any, T], *, debug: bool = False) -> T:
-    """
-    Python 3.6-compatible `asyncio.run` wrapper.
-
-    :param coro: A coroutine to execute now.
-    :return: The return value from the coroutine.
-    """
-    if sys.version_info >= (3, 7):
-        return asyncio.run(coro, debug=debug)
-
-    # Python 3.6
-    loop = asyncio.get_event_loop()
-    loop.set_debug(debug)
-    ret = loop.run_until_complete(coro)
-    loop.close()
-
-    return ret
-
-
 # ----------------------------
 # Section: Logging & Debugging
 # ----------------------------
@@ -177,8 +78,11 @@ def exception_summary(exc: BaseException) -> str:
     """
     Return a summary string of an arbitrary exception.
 
-    It will be of the form "ExceptionType: Error Message", if the error
+    It will be of the form "ExceptionType: Error Message" if the error
     string is non-empty, and just "ExceptionType" otherwise.
+
+    This code is based on CPython's implementation of
+    `traceback.TracebackException.format_exception_only`.
     """
     name = type(exc).__qualname__
     smod = type(exc).__module__
diff --git a/python/tests/protocol.py b/python/tests/protocol.py
index 56c4d441f9c..e565802516d 100644
--- a/python/tests/protocol.py
+++ b/python/tests/protocol.py
@@ -8,7 +8,6 @@
 
 from qemu.qmp import ConnectError, Runstate
 from qemu.qmp.protocol import AsyncProtocol, StateError
-from qemu.qmp.util import asyncio_run, create_task
 
 
 class NullProtocol(AsyncProtocol[None]):
@@ -124,7 +123,7 @@ async def _runner():
             if allow_cancellation:
                 return
             raise
-    return create_task(_runner())
+    return asyncio.create_task(_runner())
 
 
 @contextmanager
@@ -228,7 +227,7 @@ def async_test(async_test_method):
         Decorator; adds SetUp and TearDown to async tests.
         """
         async def _wrapper(self, *args, **kwargs):
-            loop = asyncio.get_event_loop()
+            loop = asyncio.get_running_loop()
             loop.set_debug(True)
 
             await self._asyncSetUp()
@@ -271,7 +270,7 @@ async def _watcher():
                     msg=f"Expected state '{state.name}'",
                 )
 
-        self.runstate_watcher = create_task(_watcher())
+        self.runstate_watcher = asyncio.create_task(_watcher())
         # Kick the loop and force the task to block on the event.
         await asyncio.sleep(0)
 
@@ -589,7 +588,8 @@ async def _asyncTearDown(self):
     async def testSmoke(self):
         with TemporaryDirectory(suffix='.qmp') as tmpdir:
             sock = os.path.join(tmpdir, type(self.proto).__name__ + ".sock")
-            server_task = create_task(self.server.start_server_and_accept(sock))
+            server_task = asyncio.create_task(
+                self.server.start_server_and_accept(sock))
 
             # give the server a chance to start listening [...]
             await asyncio.sleep(0)
-- 
2.48.1


