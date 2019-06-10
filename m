Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042333BF93
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 00:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390344AbfFJWrl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 18:47:41 -0400
Received: from ahs5.r4l.com ([158.69.52.156]:51592 "EHLO ahs5.r4l.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390139AbfFJWrl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 18:47:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=extremeground.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SNdH4AlrrTqd+DXj/mtVgjyljKi+GcOqyPrzOYV3Dd0=; b=NzhDzWPNNjUbr6WSrSDQ571NRa
        Z4GhxZcigD25tQigIGlacm1x7fdelWNUjNUDqbHSWJsmdV30psdNq16hrhehVc6gND11VpPoJmYTD
        5TrGkxWEREWyYnUk67Dfb3QsL2ZtXVrIboOkzIuC4yxlV35u1f2+ZBtd12W+Wmox66kWDiq7sj4S9
        hOULuA+/SyJ2m9eYEqgp5Yk6s2J7DklnEyCHUwdmRzTqF/LuU8VwJvVBtvF3O5p/vjkFOYswAdtb6
        dSuf6jksc4+a3p/zpQnoyn4D8MFnxG/irH3YFtmawVEZskguJC9XyuMowvuG0iVk8qfIoJoWMWEJx
        ihSDUPKQ==;
Received: from cpeac202ed5e073-cmac202ed5e070.cpe.net.cable.rogers.com ([99.237.87.227]:36496 helo=[192.168.1.20])
        by ahs5.r4l.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92)
        (envelope-from <gary@extremeground.com>)
        id 1haT4j-0001F4-NQ; Mon, 10 Jun 2019 18:47:37 -0400
Subject: Re: [Qemu-devel] kvm / virsh snapshot management
To:     Eric Blake <eblake@redhat.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Cc:     Kevin Wolf <kwolf@redhat.com>, John Snow <jsnow@redhat.com>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <abb7990e-0331-67a4-af92-05276366478c@extremeground.com>
 <20190610121941.GI14257@stefanha-x1.localdomain>
 <dc7a70ea-c94f-e975-df44-b0199da698e2@extremeground.com>
 <28719bbe-fcce-9e37-f146-ad6ce3edda51@redhat.com>
From:   Gary Dale <gary@extremeground.com>
Message-ID: <976b1c32-a7ff-fbfd-9176-040c61649cb7@extremeground.com>
Date:   Mon, 10 Jun 2019 18:47:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <28719bbe-fcce-9e37-f146-ad6ce3edda51@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-CA
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - ahs5.r4l.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - extremeground.com
X-Get-Message-Sender-Via: ahs5.r4l.com: authenticated_id: gary@extremeground.com
X-Authenticated-Sender: ahs5.r4l.com: gary@extremeground.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019-06-10 6:04 p.m., Eric Blake wrote:
> On 6/10/19 10:54 AM, Gary Dale wrote:
>
>>>> One explanation I've seen of the process is if I delete a snapshot, the
>>>> changes it contains are merged with its immediate child.
>>> Nope.  Deleting a snapshot decrements the reference count on all its
>>> data clusters.  If a data cluster's reference count reaches zero it will
>>> be freed.  That's all, there is no additional data movement or
>>> reorganization aside from this.
>> Perhaps not physically but logically it would appear that the data
>> clusters were merged.
> No.
>
> If I have an image that starts out as all blanks, then write to part of
> it (top line showing cluster number, bottom line showing representative
> data):
>
> 012345
> AA----
>
> then take internal snapshot S1, then write more:
>
> ABB---
>
> then take another internal snapshot S2, then write even more:
>
> ABCC--
>
> the single qcow2 image will have something like:
>
> L1 table for S1 => {
>    guest cluster 0 => host cluster 5 refcount 3 content A
>    guest cluster 1 => host cluster 6 refcount 1 content A
> }
> L1 table for S2 => {
>    guest cluster 0 => host cluster 5 refcount 3 content A
>    guest cluster 1 => host cluster 7 refcount 2 content B
>    guest cluster 2 => host cluster 8 refcount 1 content B
> }
> L1 table for active image => {
>    guest cluster 0 => host cluster 5 refcount 3 content A
>    guest cluster 1 => host cluster 7 refcount 2 content B
>    guest cluster 2 => host cluster 9 refcount 1 content C
>    guest cluster 3 => host cluster 10 refcount 1 content C
> }
>
>
> If I then delete S2, I'm left with:
>
> L1 table for S1 => {
>    guest cluster 0 => host cluster 5 refcount 2 content A
>    guest cluster 1 => host cluster 6 refcount 1 content A
> }
> L1 table for active image => {
>    guest cluster 0 => host cluster 5 refcount 2 content A
>    guest cluster 1 => host cluster 7 refcount 1 content B
>    guest cluster 2 => host cluster 9 refcount 1 content C
>    guest cluster 3 => host cluster 10 refcount 1 content C
> }
>
> and host cluster 8 is no longer in use.
>
> Or, if I instead use external snapshots, I have a chain of images:
>
> base <- mid <- active
>
> L1 table for image base => {
>    guest cluster 0 => host cluster 5 refcount 1 content A
>    guest cluster 1 => host cluster 6 refcount 1 content A
> }
> L1 table for image mid => {
>    guest cluster 1 => host cluster 5 refcount 1 content B
>    guest cluster 2 => host cluster 6 refcount 1 content B
> }
> L1 table for image active => {
>    guest cluster 2 => host cluster 5 refcount 1 content C
>    guest cluster 3 => host cluster 6 refcount 1 content C
> }
>
> If I then delete image mid, I can do so in one of two ways:
>
> blockcommit mid into base:
> base <- active
> L1 table for image base => {
>    guest cluster 0 => host cluster 5 refcount 1 content A
>    guest cluster 1 => host cluster 6 refcount 1 content B
>    guest cluster 2 => host cluster 7 refcount 1 content B
> }
> L1 table for image active => {
>    guest cluster 2 => host cluster 5 refcount 1 content C
>    guest cluster 3 => host cluster 6 refcount 1 content C
> }
>
>
> blockpull mid into active:
> base <- active
> L1 table for image base => {
>    guest cluster 0 => host cluster 5 refcount 1 content A
>    guest cluster 1 => host cluster 6 refcount 1 content A
> }
> L1 table for image active => {
>    guest cluster 1 => host cluster 7 refcount 1 content B
>    guest cluster 2 => host cluster 5 refcount 1 content C
>    guest cluster 3 => host cluster 6 refcount 1 content C
> }
>
>
>>>> Can some provide a little clarity on this? Thanks!
>>> If you want an analogy then git(1) is a pretty good one.  qcow2 internal
>>> snapshots are like git tags.  Unlike branches, tags are immutable.  In
>>> qcow2 you only have a master branch (the current disk state) from which
>>> you can create a new tag or you can use git-checkout(1) to apply a
>>> snapshot (discarding whatever your current disk state is).
>>>
>>> Stefan
>> That's just making things less clear - I've never tried to understand
>> git either. Thanks for the attempt though.
>>
>> If I've gotten things correct, once the base image is established, there
>> is a current disk state that points to a table containing all the writes
>> since the base image. Creating a snapshot essentially takes that pointer
>> and gives it the snapshot name, while creating a new current disk state
>> pointer and data table where subsequent writes are recorded.
> Not quite. Rather, for internal snapshots, there is a table pointing to
> ALL the contents that should be visible to the guest at that point in
> time (one table for each snapshot, which is effectively read-only, and
> one table for the active image, which is updated dynamically as guest
> writes happen).  But the table does NOT track provenance of a cluster,
> only a refcount.
>
>> Deleting snapshots removes your ability to refer to a data table by
>> name, but the table itself still exists anonymously as part of a chain
>> of data tables between the base image and the current state.
> Wrong for internal snapshots. There is no chain of data tables, and if a
> cluster's refcount goes to 0, you no longer have access to the
> information that the guest saw at the time that cluster was created.
>
> Also wrong for external snapshots - there, you do have a chain of data
> between images, but when you delete an external snapshot, you should
> only do so after moving the relevant data elsewhere in the chain, at
> which point you reduced the length of the chain.
>
>> This leaves a problem. The chain will very quickly get quite long which
>> will impact performance. To combat this, you can use blockcommit to
>> merge a child with its parent or blockpull to merge a parent with its
>> child.
> Wrong for internal snapshots, where blockcommit and blockpull do not
> really work.
>
> More accurate for external snapshots.
>
>> In my situation, I want to keep a week of daily snapshots in case
>> something goes horribly wrong with the VM (I recently had a database
>> file become corrupt, and reverting to the previous working day's image
>> would have been a quick and easy solution, faster than recovering all
>> the data tables from the prefious day). I've been shutting down the VM,
>> deleting the oldest snapshot and creating a new one before restarting
>> the VM.
>>
>> While your explanation confirms that this is safe, it also implies that
>> I need to manage the data table chains. My first instinct is to use
>> blockcommit before deleting the oldest snapshot, such as:
>>
>>      virsh blockcommit <vm name> <qcow2 file path> --top <oldest
>> snapshot> --delete --wait
>>      virsh snapshot-delete  --domain <vm name> --snapshotname <oldest
>> snapshot>
>>
>> so that the base image contains the state as of one week earlier and the
>> snapshot chains are limited to 7 links.
>>
>> 1) does this sound reasonable?
> If you want to track WHICH clusters have changed since the last backup
> (which is the goal of incremental/differential backups), you probably
> also want to be using persistent bitmaps.  At the moment, internal
> snapshots have very little upstream development compared to external
> snapshots, and are less likely to have ways to do what you want.
>
>> 2) I note that the syntax in virsh man page is different from the syntax
>> at
>> https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-backing-chain
>> (RedHat uses --top and --base while the man page just has optional base
>> and top names). I believe the RedHat guide is correct because the man
>> page doesn't allow distinguishing between the base and the top for a
>> commit.
> Questions about virsh are outside the realm of what qemu does (that's
> what libvirt adds on top of qemu); and the parameters exposed by virsh
> may differ according to what versions you are running. Also be aware
> that I'm trying to get a new incremental backup API
> virDomainBackupBegin() added to libvirt that will make support for
> incremental/differential backups by using qcow2 persistent bitmaps much
> easier from libvirt's point of use.
>
>> However the need for specifying the path isn't obvious to me. Isn't the
>> path contained in the VM definition?
>>
>> Since blockcommit would make it impossible for me to revert to an
>> earlier state (because I'm committing the oldest snapshot, if it screws
>> up, I can't undo within virsh), I need to make sure this command is
>> correct.
>>
>>
Interesting. Your comments are quite different from what the Redhat 
online documentation suggests. It spends some time talking about 
flattening the chains (e.g. 
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/virtualization_administration_guide/sub-sect-domain_commands-using_blockcommit_to_shorten_a_backing_chain) 
while you are saying the chains don't exist. I gather this is because 
Redhat doesn't like internal snapshots, so they focus purely on 
documenting external ones.

It does strike me as a little bizarre to handle internal and external 
snapshots differently since the essential difference only seems to be 
where the data is stored. Using chains for one and reference counts for 
the other sounds like a recipe for for things not working right.

Anyway, if I understand what you are saying, with internal snapshots, i 
can simply delete old ones and create new ones without worrying about 
there being any performance penalty. All internal snapshots are one hop 
away from the base image.

Thanks.

