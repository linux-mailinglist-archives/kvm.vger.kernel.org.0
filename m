Return-Path: <kvm+bounces-13221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96CA98934B0
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 19:11:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 238791F24262
	for <lists+kvm@lfdr.de>; Sun, 31 Mar 2024 17:11:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEC56161917;
	Sun, 31 Mar 2024 16:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eJnKUWex"
X-Original-To: kvm@vger.kernel.org
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018CB160881;
	Sun, 31 Mar 2024 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=62.96.220.36
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711903439; cv=fail; b=LxFCoCY0pv1tD1o5bCzWT20ioIXGZ8WQ5PO9o6raTD5o6jem65TmlFdRI9GEVQb1rJna6OqqtLXci1KRhHNryINcnrnloyQHK+8r4hsWMCpprQ8DTu68+zpLmIMsykYA5p5mBOJwxTk2NQKKYyJvn+DX9YegttmO3G0Uds2llJ8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711903439; c=relaxed/simple;
	bh=+CtUzNfteMVDHRuwIX5781fsmaFIlHZcyPlcQv4zDZc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aXL7Tt0gEwrWGgBiAf95YCSV9dBnldjEmicC9K142aKkDmHaGC/FM+g1Jc+7T95buJj3i6qq0sWmqfqPdAzt8eGAFhQ/fptyS3L3l9m0Ik4STA4SkkEWO6fKUbgPmU2i1pLTvnnhmFDK2SkyLJ6woxAYjl7Nk9L6pNG1ydnUEIo=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eJnKUWex; arc=fail smtp.client-ip=192.198.163.8; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; arc=fail smtp.client-ip=62.96.220.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 916C6208C8;
	Sun, 31 Mar 2024 18:43:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KMNTobHZ5srI; Sun, 31 Mar 2024 18:43:55 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id AC527208CE;
	Sun, 31 Mar 2024 18:43:54 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 a.mx.secunet.com AC527208CE
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 9F3DD800061;
	Sun, 31 Mar 2024 18:43:54 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sun, 31 Mar 2024 18:43:54 +0200
Received: from Pickup by mbx-essen-01.secunet.de with Microsoft SMTP Server id
 15.1.2507.17; Sun, 31 Mar 2024 16:37:15 +0000
X-sender: <kvm+bounces-13190-martin.weber=secunet.com@vger.kernel.org>
X-Receiver: <martin.weber@secunet.com> ORCPT=rfc822;martin.weber@secunet.com
X-CreatedBy: MSExchange15
X-HeloDomain: mbx-dresden-01.secunet.de
X-ExtendedProps: BQBjAAoAg8BQonhR3AgFADcAAgAADwA8AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5NYWlsUmVjaXBpZW50Lk9yZ2FuaXphdGlvblNjb3BlEQAAAAAAAAAAAAAAAAAAAAAADwA/AAAATWljcm9zb2Z0LkV4Y2hhbmdlLlRyYW5zcG9ydC5EaXJlY3RvcnlEYXRhLk1haWxEZWxpdmVyeVByaW9yaXR5DwADAAAATG93
X-Source: SMTP:Default MBX-ESSEN-02
X-SourceIPAddress: 10.53.40.199
X-EndOfInjectedXHeaders: 16176
X-Virus-Scanned: by secunet
Received-SPF: Pass (sender SPF authorized) identity=mailfrom; client-ip=147.75.199.223; helo=ny.mirrors.kernel.org; envelope-from=kvm+bounces-13190-martin.weber=secunet.com@vger.kernel.org; receiver=martin.weber@secunet.com 
DKIM-Filter: OpenDKIM Filter v2.11.0 b.mx.secunet.com 0F7D520199
Authentication-Results: b.mx.secunet.com;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eJnKUWex"
X-Original-To: kvm@vger.kernel.org
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal: i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711890086; cv=fail; b=a3hiClgmYEgg6PsCeDXEgoyzWxc8dB3E0sZLjHDmXAbxOMTfO+tjG1bvf4PiERYPvhGZbRKcIHnr+q7CtN5tIlf+kMLxZD4E7ykBeksXGWhtSkXCBJw9slnJqRhXWGWVHgNYsARqDo+50qxmVdVxEr+P02lWdTwVylnBdk4ZfBc=
ARC-Message-Signature: i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711890086; c=relaxed/simple;
	bh=+CtUzNfteMVDHRuwIX5781fsmaFIlHZcyPlcQv4zDZc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hsf4Eq0/nQxGKbWFZS7VuDw0WznDMnzSYMs9rUrx2VGPY+ZRBGxNESLTIpjHsGRnWn648Z2kdZh8Ri/J1yLuRN6kzMsKH+zZhsohatpGg2qepVc0pMs/Yy9552APnsRpLDkVExgRus/nvOI6cToLsW7IZx0gKpWdaeMCI9LO04s=
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eJnKUWex; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711890084; x=1743426084;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+CtUzNfteMVDHRuwIX5781fsmaFIlHZcyPlcQv4zDZc=;
  b=eJnKUWexGjflXeP+jYDmhHbpZLyVNN9GppFJ1EVpa6Wz34tbK/5mBB+w
   C/50vXqD8mvKAp/DBxawj/C/DC7oCitZnoW2x35SiF0yRSts9ImWnMV56
   fyPOLS0HsdbzZPBp7AkZdRW6G3b0Y85y7x2WNU01dfaICNuPHJZyDZsON
   Q+maFT0XztgbHGGGit8eUpAkmTV3sfXZt89ZJQL+zS7FVHeTzuJH5GNBC
   h8dtJZftTkO687fyG5x3I6b9Oa+Vzs1lq5uW2HMNCtw0d/pS3UwVpTJhM
   kzcYb8BXiBRMx3LC5b8wLC+XyLAbPGyuuS9ijYP6rrZ/R+5BS0np90LG5
   w==;
X-CSE-ConnectionGUID: 626C+LZ8TBeS18zb+phhYA==
X-CSE-MsgGUID: ky71nFTkQBGE9RDPFjzKMQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11029"; a="24513264"
X-IronPort-AV: E=Sophos;i="6.07,170,1708416000"; 
   d="scan'208";a="24513264"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,170,1708416000"; 
   d="scan'208";a="22133090"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aID8BjwRCmRaqH3tzxEKd9og1erEG+uKa+J+hCHKZikQ8YRQoEdn+4twiQ0zHRhG+IyPyf025UILojTK3/sg/yQN91zKxrWZLQNeyuVJ5nchtSnXXUGcrZYWfF0afg6bBiBYw76lCyRID+XkuGcKr7nji4vWvtUiWt1BEe++9NNw83AkusD9lxuTLXkX9006YMS/p0ryLs+9OaLwhYTbm5jm89zJUyP/6pLxYou0DsL6ikxFlEFkM4gCU0HH+gpguuUsYXa9Qu8OunlKcYdipFRDiwATFsV2nzP+10j5PCcM5HBZLuluzuXzFEDx6jEp0SNkj+oYLrm9b4Jtpz46lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+CtUzNfteMVDHRuwIX5781fsmaFIlHZcyPlcQv4zDZc=;
 b=G9H0k2LGO7S5UAA9/s6wCZ1nNJ13gr/rXbQdwUhc6CZi0JdGZU8hjUwRpFBw3TLR7r1xSKcGuqeaYMybdiY8RaPQTwFlEznE2d4WvXnsTH/CzASvBw/GJatRiAL3oIv/4iXoNIIH81L3FVucmjj4zpJlmkbRF/cNIjyl4pjN13e/WOw7a9Xxk0fEhetWFpFH37JrBJtlAY5hhiOO2QXrWoN5J4vsz/wGK/0ApF4k4btTPoKaCbBIbQQ8MYAwjy13an11Mo+927inpsssThArav8Azk1B71ffe1BwnFQzli+4EgvmS7uKNrOp7wN2/HZslcZNkVBLglQJgzVDMky8oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, David Skidmore
	<davidskidmore@google.com>, Steve Rutherford <srutherford@google.com>,
	"Gupta, Pankaj" <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [ANNOUNCE] PUCK Agenda - 2024.03.13 - No topic
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2024.03.13 - No topic
Thread-Index: AQHadN35f9AVk6ft0UyFv8Aerb6gU7FR5xUQ
Date: Sun, 31 Mar 2024 13:01:20 +0000
Message-ID: <DS0PR11MB6373543451F0505C220F2C8ADC382@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240313003211.1900117-1-seanjc@google.com>
In-Reply-To: <20240313003211.1900117-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SA2PR11MB5132:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QgBcP03amZ53dI/UAmFRc2tlaOj1ZKCJpRu6fFucFd98i31/PGN1DPJispkPDLxf3P1xGfPAbfZODY7/y+FSMcjruBNXne0TmpusX/srwABWDTp5Rh1HglCcIep2YJbRaid1mZZytkV8tZxe0YiGWiNUEMrOSKSAFhO4nycLqyQiDuRRKbZVZw1m+HqeSMaMFs5cWMg5k6/GrIXuQP1wKGtjAqAB4Hh6D2ChXUIU2DdCXcO3JtKxuXKH3k4+7i6b4k+t3hNwx7tzqIph3STTm6TxtnE8L+u4uQ5BZlkF8CeRVlsEkp8aSadslgRFjnc/vrOhpdbwZwE8d7rsJzyZBcVGoTQSXEekJ9Y/05NoYZBqjxGzcACBMRwbWzb3oxuMfyHxWMVZxiyfBxEI3aiK0IjTzD84lVcC7L6R7970AyJt+7PusTkqIafS/MXhCsscg8/+Q9aNf99hpJEloJ2Uwpy9JKLYAm43ohLAYE+zDBYKe+qUMXpsbYZ6/DNytCsl8jzvATgkdq1oUjUjY+P3sUH9/QijMyJ3ZCMsPykbW26cU/S70dMJWHx7H7mngZ9hNAkL360qvbQ2QCliSbYWgCQNvoEwdL2jbwy+9NDdQDezd6IfPSMhK33J1FmZVKRChuVkl2oOvQB3fYKd9yEV1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnBKOUZzOUF2aTlsbnEwaXJ4UGFyeExyTkNob2c5d2JISDBEY3lNNFo1VzMw?=
 =?utf-8?B?cDBCWlhHbFpzQk1Hcm9SckdIY2h3UW1BM1lyTUlablZmMWZUc0tVZW95S2N0?=
 =?utf-8?B?Szl6Vi9BZHowL1VPV3BhZFk4VC9wbEowTnZGcG5IWXBKcXRxakEzMXJFOEtz?=
 =?utf-8?B?M1huWVhIZFk5bjRYK2xqT1BoYlVaODdIakxaR2p2OUIvNVc5V3VqMisyUHRU?=
 =?utf-8?B?aWdZMTFvZGVlMWZTOGdWMHFTOWFrbk5LdkYyMTRMc3dkNVc1VkZBN1BSa1Fu?=
 =?utf-8?B?SnpBVEtwODExczFyb2NGTU5lTFVJWm9mekdvQ3gxcDVWN3JYaE5jbTlaMmVU?=
 =?utf-8?B?SWkzcnlFL0xVMWhDZUdsSGZkNXBIaWtGWmc2T3p2R2lCMStZRS8zdXZ1VzJT?=
 =?utf-8?B?R3l5TWRVVmFsYVVkK1gvRm1qdUtBeFViVVJLa1Z1Rm1VVks1TWsrdnRZVWZo?=
 =?utf-8?B?WDlYRlloeElnMUZvYmJwR0FhYzM1aTJVVDF2MlhNV3dyYXByNDJVZS9lK2JW?=
 =?utf-8?B?dm80QnNCU21oc3l3Ti9Da3lsK0pxaThRL2lPSzY2RjlPZlNuWmtyTHl5M3ZO?=
 =?utf-8?B?T1pKa3RPcWlWWTltNnFPNDJ2b0V0MHkyNjJLVFc4UURnZk5HVHZ0OGhiU2lF?=
 =?utf-8?B?QktqL09JV1R2NEFyclFuZHhZTE5lTDhoOHRxeVBmTlFxRkc3alNxYUtlODFi?=
 =?utf-8?B?ZjZ3clRzcWJ0ZVlPV0c4ZkM4S2xmTHZQTW5QMVdmWUhaUzY4VEdGNWJweDFp?=
 =?utf-8?B?bHNyaFNiSU5qWjBYQVZRSW9qdDFZN0lHRVZiNkNpeEZ6K3FsSmFiUmFicEJk?=
 =?utf-8?B?cE45TDN6d0JjN3FrejhHNmhhTEVPM3Z4TmV3QmNhR1ZFYXcyNEhzL05XQWVK?=
 =?utf-8?B?ampWTllyeGlKbG1LdXlUNmJwck5EVzkxUFp2eE5hZTF5NmViMDlKQ08wSG9K?=
 =?utf-8?B?UGNOcUFaaHo1azdSSWxDSC9jd0NXQU5vbVBqVVhYU04yeXdJSk1tYzVoOERC?=
 =?utf-8?B?WHI3WHdxdmxzMXZVQ3pmamhYWG5DWDMxVkxpNEtLdGhhZGV3SlZTbXdWOXBT?=
 =?utf-8?B?TEt1VXNHWXRsZXcrakE0cy9wUjNLZ3IzTGNwRlRWaUhtU1dFWmJraTd1TDBQ?=
 =?utf-8?B?d0FKREcyNWlWWHNEZlA0Uno3OXJKVUdGYUMvL0c2TzlSSWI3UUd0Ym1LRW1v?=
 =?utf-8?B?UnIvQXRUUEpIa0lNUnloMmYrdklQeFBNUHZKenlpVmpKaDFsNVNhUFNhWlZr?=
 =?utf-8?B?Y2VrZE8wRTJqd3Z3MzBGdjFFN3IraWFNSUhpWmZWNDNYNTgrajdLSStFc2JT?=
 =?utf-8?B?NTdDYXc0SEdDNU5qa2JWVndmZ25DeEQyeXJKMmVLRkRTYW8rUUdhY001cHlJ?=
 =?utf-8?B?N1E5NDFVVlpqaVl3bHo0VjQxK3h0bEF5SXB4cFhTZnF3MkFISUFRckJ5QWh5?=
 =?utf-8?B?eHBCOVFuRWRUYTM4NjFGbUpZeVNXZmQ1cnFaL1VuSFZ2Ujg0L2QzTnlURUJ2?=
 =?utf-8?B?WkMrQUx3Q2plNWNZUWJSU0xpTG90L3lmMXQ0eDVJRG1OSEFzZm9MNUhESmEz?=
 =?utf-8?B?a0liVExBcFZVWlRPWkR4L0Z5ZUlrMGhGUC9GNVRGRUd5N0NPSy94U0FaNWlT?=
 =?utf-8?B?dXBTVUJtSy84YXg4SFlaakdUTHpXU0Y4ZUtnZllqVlFUWXNmVFcweHY4T25u?=
 =?utf-8?B?WjdIQTdrdDd4cUo4TGpndWJsbDduOE1sV1JJM2ZqNWp2bEhYbmVpM2k3cnZG?=
 =?utf-8?B?VXZMaG1RYW93YjNQUlN3elRLUG9jOUdNRGtKRHdidlV2UVAvUWxjSENRYWFt?=
 =?utf-8?B?WExrL3Y1eVdrN09pMmI1QlRUdDZLZUJLUDFpd2FQVFA4Y3FLUnhCN1ZESytG?=
 =?utf-8?B?L1RHWmR0dHJRYktxTHUxL1drVHBDNVRXcXRBOFNOS3lFdndObWhGZ3FFNkEx?=
 =?utf-8?B?bHlCc3BRWk4xUjZvd0xoMjBQK1BSOFV3TktDRlI4TU9xU0MrMDdQL08zWlAx?=
 =?utf-8?B?Mm5UOFhpTWtyYkhuM3U3WHF2UzRmdkdrSVo2NThoM3pOODVlSS9WY2RNSGdG?=
 =?utf-8?B?MVR2UDJhRk11bHJQWmp1bzM1cVZTQmptY09pa0VsWkJUWHljQ01LUkNOb2Rj?=
 =?utf-8?Q?KNcHc3Hrny7KnugxNfoXxhdvj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3194b329-bec7-4299-4972-08dc5182a91c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2024 13:01:20.4431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZYB8fLIBd7IEgM3h/0CG0yZ0++vphMrcWLRFWpnyBCQN6W+E+nycDOsodwBUmti0OXWvG7kXYRH9Th7VyZdK4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5132
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10

T24gV2VkbmVzZGF5LCBNYXJjaCAxMywgMjAyNCA4OjMyIEFNLCBTZWFuIENocmlzdG9waGVyc29u
IHdyb3RlOg0KPiBUbzogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+
IENjOiBrdm1Admdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+
IFN1YmplY3Q6IFtBTk5PVU5DRV0gUFVDSyBBZ2VuZGEgLSAyMDI0LjAzLjEzIC0gTm8gdG9waWMN
Cj4gDQo+IE5vIHRvcGljIGZvciB0b21vcnJvdywgYnV0IEknbGwgYmUgb25saW5lLg0KPiANCj4g
Tm90ZSwgdGhlIFVTIGp1c3QgZGlkIGl0cyBEYXlsaWdodCBTYXZpbmdzIHRoaW5nLCBzbyB0aGUg
bG9jYWwgdGltZSBtaWdodCBiZQ0KPiBkaWZmZXJlbnQgZm9yIHlvdSB0aGlzIHdlZWsuDQo+IA0K
PiBOb3RlICMyLCBQVUNLIGlzIGNhbmNlbGVkIGZvciB0aGUgbmV4dCB0d28gd2Vla3MgYXMgSSds
bCBiZSBvZmZsaW5lLg0KPiANCj4gRnV0dXJlIFNjaGVkdWxlOg0KPiBNYXJjaCAgICAyMHRoIC0g
Q0FOQ0VMRUQNCj4gTWFyY2ggICAgMjd0aCAtIENBTkNFTEVEDQoNCldvdWxkIHRoZXJlIGJlIGEg
c2xvdCBhdmFpbGFibGUgb24gQXByaWwgM3JkPw0KSSdkIGxpa2UgdG8gaGF2ZSBhIGRpc2N1c3Np
b24gYWJvdXQgS1ZNIHVBUElzIGZvciBURFggYW5kIFNOUCBMaXZlIE1pZ3JhdGlvbi4NCg0KQ0Mg
dGhlIG9uZXMgd2hvIHdvdWxkIGJlIGludGVyZXN0ZWQgaW4gam9pbmluZyB0aGUgZGlzY3Vzc2lv
bi4NCihIb3BlIG1vcmUgZm9sa3Mgd29ya2luZyBvbiB0aGUgU05QIG1pZ3JhdGlvbiBwYXJ0IGNv
dWxkIGpvaW4pDQoNClRoYW5rcywNCldlaQ0K


