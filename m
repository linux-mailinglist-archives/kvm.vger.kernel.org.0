Return-Path: <kvm+bounces-30179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 008189B7B20
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 13:54:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0B25287449
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 12:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD0119D08A;
	Thu, 31 Oct 2024 12:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EW+h7GMp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672A719CC2E
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730379265; cv=none; b=EeUOFPS8tgegP21a8SkWX+l/0AMcqjGJKtajeKRqWu9aYv8VHSA55040HDWoABiVACTVdkMM6MO98/Omrvjh1ARn+gslvy84tgIVg97hu/4DVBznD1qVES1Oe7wi+CB3HAbmxK6/+L/GFCtT5II3W5D0sEF+3OPZmmBnklIP24A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730379265; c=relaxed/simple;
	bh=idy4Itzy9YYlpWbMeftrahCfIPL4wIrXMPi2l930V9U=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bZO+l93UeVHttwHxa+6Ws4cHPbmo7tI9u6/9EpdnbzlMMbIo04ie+HevC9uKpaT+6CjinxAOrTcYevzw1jfSS9Jp+5sg9H6mOGCNNKfKZ76L1Plg8KiV21tQHvKaUbvnPgVzdz49nh6QmIJJbYGJ49rb4Vrngb2jjv3NrbxFnWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EW+h7GMp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730379261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=nEZ7Ebb4KpSyNTow6eMbvILiK+xSILLOTIBFlrBQkxw=;
	b=EW+h7GMp0VGw2Fb6VcQ4iY2lvucyU7InIC77rZk12+Z4ZvmVhMZFMd7GRS1u6sVP4O9RCQ
	TMiHVCxVZycnft4y+XR4MZo/jTn/OAC5r96TuSZy5dRXP/5oFC5TBuTDxiXFBK9Z0YEbX3
	1UwTbsMBa+bbfWDedvXXGWg9zN5RYOI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-EPI1q_kwOZCsdEgGmRv12g-1; Thu,
 31 Oct 2024 08:54:19 -0400
X-MC-Unique: EPI1q_kwOZCsdEgGmRv12g-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 826CD19560AA;
	Thu, 31 Oct 2024 12:54:12 +0000 (UTC)
Received: from pinwheel (unknown [10.39.194.127])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 052201956086;
	Thu, 31 Oct 2024 12:54:09 +0000 (UTC)
Date: Thu, 31 Oct 2024 13:54:07 +0100
From: Kashyap Chamarthy <kchamart@redhat.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, rust-vmm@lists.opendev.org,
	devel@lists.libvirt.org
Subject: [Call for Presentations] FOSDEM 2025: Virt & IaaS devroom
Message-ID: <ZyN97_nF4Vz0ten1@pinwheel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

(Cross-posted to KVM, Rust-VMM, QEMU, and libvirt lists.)

Hi,

The CFP for the 'Virt & IaaS' (Infrastructure as a Service) 2025
"devroom" is out[+].

  - Where? — Brussels, Belgium
  - When?  — 02 Feb (Sunday) 2025
  - Talk submission deadline — 01 Dec 2024

    (The CFP submission on the FOSDEM list[+] says 08 Dec 2024 is the
    submission deadline in its intro paragraph.  But I clarified it with
    Piotr Kliczewski, the deddline is *01* Dec 2024 and _not_ 08th Dec;
    I updated it below.)

========================================================================
This devroom is a collaborative effort, and is organized by dedicated
folks from projects such as OpenStack, Xen Project, KubeVirt, QEMU, KVM,
and Foreman.  We invite everyone involved in these fields to submit your
proposals by December *1st* 2024. 

Important Dates
---------------

Submission deadline: 1st December 2024

Acceptance notifications: 10th December 2024

Final schedule announcement: 15th December 2024

Devroom: 2nd February 2025


About the Devroom
-----------------

The Virtualization & IaaS devroom will feature session topics such as open
source hypervisors or virtual machine managers such as Xen Project, KVM,
bhyve and VirtualBox as well as Infrastructure-as-a-Service projects such
as KubeVirt, Apache CloudStack, OpenStack, QEMU and OpenNebula.

This devroom will host presentations that focus on topics of shared
interest, such as KVM; libvirt; shared storage; virtualized networking;
cloud security; clustering and high availability; interfacing with multiple
hypervisors; hyperconverged deployments; and scaling across hundreds or
thousands of servers.

Presentations in this devroom will be aimed at developers working on these
platforms who are looking to collaborate and improve shared infrastructure
or solve common problems. We seek topics that encourage dialog between
projects and continued work post-FOSDEM.


Submit Your Proposal
--------------------

All submissions must be made via the Pretalx event planning site[1]. It is
a new submission system so you will need to create an account. If you
submitted proposals for FOSDEM in previous years, you won’t be able to use
your existing account.

During submission please make sure to select Virtualization and Cloud
infrastructure from the Track list. Please provide a meaningful abstract
and description of your proposed session.


Submission Guidelines
---------------------

We expect more proposals than we can possibly accept, so it is vitally
important that you submit your proposal on or before the deadline. Late
submissions are unlikely to be considered.

All presentation slots are 30 minutes, with 20 minutes planned for
presentations, and 10 minutes for Q&A.

All presentations will be recorded and made available under Creative
Commons licenses. In the Submission notes field, please indicate that you
agree that your presentation will be licensed under the CC-By-SA-4.0 or
CC-By-4.0 license and that you agree to have your presentation recorded.
For example:

"If my presentation is accepted for FOSDEM, I hereby agree to license all
recordings, slides, and other associated materials under the Creative
Commons Attribution Share-Alike 4.0 International License.

Sincerely,

<NAME>."

In the Submission notes field, please also confirm that if your talk is
accepted, you will be able to attend FOSDEM and deliver your presentation.
We will not consider proposals from prospective speakers who are unsure
whether they will be able to secure funds for travel and lodging to attend
FOSDEM. (Sadly, we are not able to offer travel funding for prospective
speakers.)


Code of Conduct
---------------

Following the release of the updated code of conduct for FOSDEM[3], we'd
like to remind all speakers and attendees that all of the presentations and
discussions in our devroom are held under the guidelines set in the CoC and
we expect attendees, speakers, and volunteers to follow the CoC at all
times.

If you submit a proposal and it is accepted, you will be required to
confirm that you accept the FOSDEM CoC. If you have any questions about the
CoC or wish to have one of the devroom organizers review your presentation
slides or any other content for CoC compliance, please email us and we will
do our best to assist you.

Questions?
----------

If you have any questions about this devroom, please send your questions to

our devroom mailing list. You can also subscribe to the list to receive

updates about important dates, session announcements, and to connect with

other attendees.

See you all at FOSDEM!

[1] https://fosdem.org/submit

[2] virtualization-devroom-manager at fosdem.org

[3] https://fosdem.org/2025/practical/conduct/
========================================================================

[+] https://lists.fosdem.org/pipermail/fosdem/2024q4/003574.html

-- 
/kashyap


